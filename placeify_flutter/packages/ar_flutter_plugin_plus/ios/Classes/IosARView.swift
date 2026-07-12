import Flutter
import UIKit
import Foundation
import ARKit
import Combine
import ARCoreCloudAnchors

class IosARView: NSObject, FlutterPlatformView, ARSCNViewDelegate, UIGestureRecognizerDelegate, ARSessionDelegate {
    let sceneView: ARSCNView
    let coachingView: ARCoachingOverlayView
    let sessionManagerChannel: FlutterMethodChannel
    let objectManagerChannel: FlutterMethodChannel
    let anchorManagerChannel: FlutterMethodChannel
    var showPlanes = false
    var customPlaneTexturePath: String? = nil
    private var trackedPlanes = [UUID: (SCNNode, SCNNode)]()
    let modelBuilder = ArModelBuilder()
    
    var cancellableCollection = Set<AnyCancellable>() //Used to store all cancellables in (needed for working with Futures)
    var anchorCollection = [String: ARAnchor]() //Used to bookkeep all anchors created by Flutter calls
    
    private var cloudAnchorHandler: CloudAnchorHandler? = nil
    private var arcoreSession: GARSession? = nil
    private var arcoreMode: Bool = false
    private var configuration: ARWorldTrackingConfiguration!
    private var tappedPlaneAnchorAlignment = ARPlaneAnchor.Alignment.horizontal // default alignment

    private var lastImageUpdateTime: [String: TimeInterval] = [:]
    private var continuousImageTracking: Bool = false
    private var imageTrackingUpdateInterval: TimeInterval = 0.1
    private var autoHideCoachingOverlay: Bool = true
    private var coachingOverlayDismissed: Bool = false
    private var hasReportedPlaneDetection: Bool = false
    
    private var panStartLocation: CGPoint?
    private var panCurrentLocation: CGPoint?
    private var panCurrentVelocity: CGPoint?
    private var panCurrentTranslation: CGPoint?
    private var rotationStartLocation: CGPoint?
    private var rotatingNode: SCNNode?
    private var lastRotationRadians: CGFloat = 0
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var rotationGestureRecognizer: UIRotationGestureRecognizer?
    private var panningNode: SCNNode?
    private var panningNodeCurrentWorldLocation: SCNVector3?
    private var lightIntensityMultiplier: CGFloat = 1.0
    private var flutterNodeNames = Set<String>()
    private static var cachedReferenceImages: [String: Set<ARReferenceImage>] = [:]

    // MARK: - Floor reference & drag validation (Android parity)
    private var referenceFloorY: Float?
    private var placementInteriorPose: simd_float4x4?
    private var shadowFloorNode: SCNNode?
    private var directionalLightNode: SCNNode?
    private var trackedFurnitureNode: SCNNode?
    private var lastLightDirection = SCNVector3(-0.3, -0.8, -0.3)
    private var pendingAnchorAttachments: [UUID: (SCNNode, String, (Bool) -> Void)] = [:]
    private var depthOcclusionEnabled = false
    private let deviceSupportsLiDARMesh: Bool
    private var lastPanNotifiedTransform: simd_float4x4?

    private let maxFloorDeviationM: Float = 0.12
    private static let maxDragPlaneHeightBandM: Float = 0.15
    private static let maxDragSurfaceElevationM: Float = 0.03
    private static let minWallClearanceFaceM: Float = 0.12
    private static let minWallClearanceCornerM: Float = 0.04
    private static let wallCornerDetectRangeM: Float = 0.35
    private static let minPlaneEdgeMarginM: Float = 0.06
    private static let maxDragJumpM: Float = 0.25
    private static let dragSmoothFactor: Float = 0.45
    private static let defaultShadowAlpha: CGFloat = 0.45
    private static let transformEpsilon: Float = 1e-5

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        self.sceneView = ARSCNView(frame: frame)
        self.coachingView = ARCoachingOverlayView(frame: frame)
        if #available(iOS 13.4, *) {
            deviceSupportsLiDARMesh = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        } else {
            deviceSupportsLiDARMesh = false
        }
        
        // Real-time light estimation drives IBL + directional light; no static HDR multiplier.
        self.sceneView.autoenablesDefaultLighting = false
        self.sceneView.automaticallyUpdatesLighting = true
        
        self.sessionManagerChannel = FlutterMethodChannel(name: "arsession_\(viewId)", binaryMessenger: messenger)
        self.objectManagerChannel = FlutterMethodChannel(name: "arobjects_\(viewId)", binaryMessenger: messenger)
        self.anchorManagerChannel = FlutterMethodChannel(name: "aranchors_\(viewId)", binaryMessenger: messenger)
        super.init()

        setupDirectionalLight()

        let configuration = ARWorldTrackingConfiguration() // Create default configuration before initializeARView is called
        self.sceneView.delegate = self
        self.coachingView.delegate = self
        self.sceneView.session.run(configuration)
        self.sceneView.session.delegate = self

        self.sessionManagerChannel.setMethodCallHandler(self.onSessionMethodCalled)
        self.objectManagerChannel.setMethodCallHandler(self.onObjectMethodCalled)
        self.anchorManagerChannel.setMethodCallHandler(self.onAnchorMethodCalled)
    }

    private func applyLightIntensityMultiplier(_ multiplier: NSNumber?) {
        let value = CGFloat(truncating: multiplier ?? 1.0)
        let clamped = max(0.01, value)
        lightIntensityMultiplier = clamped
        if let frame = sceneView.session.currentFrame,
           let estimate = frame.lightEstimate {
            applyLightEstimate(estimate)
        }
        sceneView.autoenablesDefaultLighting = false
        sceneView.automaticallyUpdatesLighting = true
    }

    private func setupDirectionalLight() {
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = .directional
        light.castsShadow = true
        light.shadowMode = .deferred
        light.shadowColor = UIColor.black.withAlphaComponent(Self.defaultShadowAlpha)
        light.shadowSampleCount = 16
        light.shadowRadius = 1.0
        light.shadowMapSize = CGSize(width: 2048, height: 2048)
        light.automaticallyAdjustsShadowProjection = false
        light.orthographicScale = 2
        light.zNear = 0.05
        light.zFar = 10
        light.intensity = 800
        lightNode.light = light
        lightNode.eulerAngles = SCNVector3(-Float.pi / 3, Float.pi / 4, 0)
        sceneView.scene.rootNode.addChildNode(lightNode)
        directionalLightNode = lightNode
    }

    private func repositionDirectionalLight() {
        guard let target = trackedFurnitureNode?.worldPosition else { return }
        let dir = lastLightDirection
        let distance: Float = 3
        directionalLightNode?.position = SCNVector3(
            target.x - dir.x * distance,
            target.y - dir.y * distance,
            target.z - dir.z * distance
        )
        directionalLightNode?.look(at: target)
    }

    private func applyLightEstimate(_ estimate: ARLightEstimate) {
        let ambientIntensity = estimate.ambientIntensity
        let ambientColorTemp = estimate.ambientColorTemperature
        sceneView.scene.lightingEnvironment.intensity =
            CGFloat(ambientIntensity / 1000.0) * lightIntensityMultiplier

        if let directional = estimate as? ARDirectionalLightEstimate {
            directionalLightNode?.light?.temperature = CGFloat(ambientColorTemp)
            let dir = directional.primaryLightDirection
            lastLightDirection = SCNVector3(dir.x, dir.y, dir.z)
            repositionDirectionalLight()
        } else {
            directionalLightNode?.light?.temperature = CGFloat(ambientColorTemp)
        }
    }

    func view() -> UIView {
        return self.sceneView
    }

    func onDispose(_ result:FlutterResult) {
                sceneView.session.pause()
                self.sessionManagerChannel.setMethodCallHandler(nil)
                self.objectManagerChannel.setMethodCallHandler(nil)
                self.anchorManagerChannel.setMethodCallHandler(nil)
                result(nil)
            }

    func onSessionMethodCalled(_ call :FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>

        switch call.method {
            case "init":
                //self.sessionManagerChannel.invokeMethod("onError", arguments: ["SessionTEST from iOS"])
                //result(nil)
                initializeARView(arguments: arguments!, result: result)
                break
            case "getCameraPose":
                if let cameraPose = sceneView.session.currentFrame?.camera.transform {
                    result(serializeMatrix(cameraPose))
                } else {
                    result(FlutterError())
                }
                break
            case "getAnchorPose":
            if let cameraPose = anchorCollection[arguments?["anchorId"] as! String]?.transform {
                    result(serializeMatrix(cameraPose))
                } else {
                    result(FlutterError())
                }
                break
            case "snapshot":
                DispatchQueue.main.async {
                    let snapshotImage = self.sceneView.snapshot()
                    guard let data = snapshotImage.jpegData(compressionQuality: 0.85) else {
                        result(FlutterError(
                            code: "SNAPSHOT_FAILED",
                            message: "Could not encode snapshot",
                            details: nil))
                        return
                    }
                    result(FlutterStandardTypedData(bytes: data))
                }
                break
            case "setLightIntensityMultiplier":
                applyLightIntensityMultiplier(arguments?["multiplier"] as? NSNumber)
                result(nil)
                break
            case "setShowPlanes":
                if let show = arguments?["show"] as? Bool {
                    showPlanes = show
                    for plane in trackedPlanes.values {
                        plane.1.isHidden = !show
                    }
                }
                result(nil)
                break
            case "setDepthOcclusionEnabled":
                let enabled = arguments?["enabled"] as? Bool ?? false
                applyDepthOcclusionEnabled(enabled)
                result(nil)
                break
            case "hitTestScreenCenter":
                let center = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
                let planeTypes: ARHitTestResult.ResultType
                if #available(iOS 11.3, *) {
                    planeTypes = [.existingPlaneUsingGeometry, .estimatedHorizontalPlane, .featurePoint]
                } else {
                    planeTypes = [.existingPlaneUsingExtent, .featurePoint]
                }
                let hits = sceneView.hitTest(center, types: planeTypes)
                result(hits.map { serializeHitResult($0) })
                break
            case "hitTestNormalized":
                let nx = (arguments?["x"] as? NSNumber)?.doubleValue ?? 0.5
                let ny = (arguments?["y"] as? NSNumber)?.doubleValue ?? 0.5
                let point = CGPoint(
                    x: sceneView.bounds.width * CGFloat(nx),
                    y: sceneView.bounds.height * CGFloat(ny)
                )
                let planeTypesNorm: ARHitTestResult.ResultType
                if #available(iOS 11.3, *) {
                    planeTypesNorm = [.existingPlaneUsingGeometry, .estimatedHorizontalPlane, .featurePoint]
                } else {
                    planeTypesNorm = [.existingPlaneUsingExtent, .featurePoint]
                }
                let normHits = sceneView.hitTest(point, types: planeTypesNorm)
                result(normHits.map { serializeHitResult($0) })
                break
            case "dispose":
                onDispose(result)
                result(nil)
                break
            case "updateImageTrackingSettings":
                applyImageTrackingSettings(
                    trackingImagePaths: arguments?["trackingImagePaths"] as? [String],
                    continuous: arguments?["continuousImageTracking"] as? Bool,
                    intervalMs: arguments?["imageTrackingUpdateIntervalMs"] as? NSNumber
                )
                result(nil)
                break
            case "precompileImageTrackingDatabase":
                let imagePaths = arguments?["trackingImagePaths"] as? [String] ?? []
                precompileImageTrackingDatabase(imagePaths: imagePaths) { success in
                    result(success)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    func onObjectMethodCalled(_ call :FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>
          
        switch call.method {
            case "init":
                if let iosScaleFactor = arguments?["iosScaleFactor"] as? NSNumber {
                    self.modelBuilder.iosModelScaleFactor = iosScaleFactor.floatValue
                }
                if let targetHeight = arguments?["targetHeightMeters"] as? NSNumber {
                    self.modelBuilder.targetHeightMeters = targetHeight.floatValue
                }
                result(nil)
                break
            case "addNode":
                addNode(dict_node: arguments!).sink(receiveCompletion: {completion in }, receiveValue: { val in
                       result(val)
                    }).store(in: &self.cancellableCollection)
                break
            case "addNodeToPlaneAnchor":
                if let dict_node = arguments!["node"] as? Dictionary<String, Any>, let dict_anchor = arguments!["anchor"] as? Dictionary<String, Any> {
                    addNode(dict_node: dict_node, dict_anchor: dict_anchor).sink(receiveCompletion: {completion in }, receiveValue: { val in
                           result(val)
                        }).store(in: &self.cancellableCollection)
                }
                break
            case "removeNode":
                if let name = arguments!["name"] as? String {
                    sceneView.scene.rootNode.childNode(withName: name, recursively: true)?.removeFromParentNode()
                    flutterNodeNames.remove(name)
                }
                break
            case "transformationChanged":
                if let name = arguments!["name"] as? String, let transform = arguments!["transformation"] as? Array<NSNumber> {
                    transformNode(name: name, transform: transform)
                    result(nil)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    func onAnchorMethodCalled(_ call :FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>
          
        switch call.method {
            case "init":
                self.objectManagerChannel.invokeMethod("onError", arguments: ["ObjectTEST from iOS"])
                result(nil)
                break
            case "addAnchor":
                if let type = arguments!["type"] as? Int {
                    switch type {
                    case 0: //Plane Anchor
                        if let transform = arguments!["transformation"] as? Array<NSNumber>, let name = arguments!["name"] as? String {
                            addPlaneAnchor(transform: transform, name: name)
                            result(true)
                        } else {
                            result(false)
                        }
                    default:
                        result(false)
                    }
                } else {
                    result(false)
                }
                break
            case "removeAnchor":
                if let name = arguments!["name"] as? String {
                    deleteAnchor(anchorName: name)
                }
                break
            case "initGoogleCloudAnchorMode":
                arcoreSession = try! GARSession.session()

                if (arcoreSession != nil){
                    let configuration = GARSessionConfiguration();
                    configuration.cloudAnchorMode = .enabled;
                    arcoreSession?.setConfiguration(configuration, error: nil);
                    if let token = JWTGenerator().generateWebToken(){
                        arcoreSession!.setAuthToken(token)
                        
                        cloudAnchorHandler = CloudAnchorHandler(session: arcoreSession!)
                        arcoreSession!.delegate = cloudAnchorHandler
                        arcoreSession!.delegateQueue = DispatchQueue.main
                        
                        arcoreMode = true
                    } else {
                        sessionManagerChannel.invokeMethod("onError", arguments: ["Error generating JWT, have you added cloudAnchorKey.json into the example/ios/Runner directory?"])
                    }
                } else {
                    sessionManagerChannel.invokeMethod("onError", arguments: ["Error initializing Google AR Session"])
                }
                    
                break
            case "uploadAnchor":
                if let anchorName = arguments!["name"] as? String, let anchor = anchorCollection[anchorName] {
                    print("---------------- HOSTING INITIATED ------------------")
                    if let ttl = arguments!["ttl"] as? Int {
                        cloudAnchorHandler?.hostCloudAnchorWithTtl(anchorName: anchorName, anchor: anchor, listener: cloudAnchorUploadedListener(parent: self), ttl: ttl)
                    } else {
                        cloudAnchorHandler?.hostCloudAnchor(anchorName: anchorName, anchor: anchor, listener: cloudAnchorUploadedListener(parent: self))
                    }
                }
                result(true)
                break
            case "downloadAnchor":
                if let anchorId = arguments!["cloudanchorid"] as? String {
                    print("---------------- RESOLVING INITIATED ------------------")
                    cloudAnchorHandler?.resolveCloudAnchor(anchorId: anchorId, listener: cloudAnchorDownloadedListener(parent: self))
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    func initializeARView(arguments: Dictionary<String,Any>, result: FlutterResult){
        // Set plane detection configuration
        self.configuration = ARWorldTrackingConfiguration()
        self.configuration.environmentTexturing = .automatic
        if #available(iOS 13.0, *) {
            self.configuration.wantsHDREnvironmentTextures = true
        }
        if #available(iOS 14.0, *),
           ARWorldTrackingConfiguration.supportsFrameSemantics(.smoothedSceneDepth) {
            configuration.frameSemantics.insert(.smoothedSceneDepth)
        } else if #available(iOS 13.0, *),
                  ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
        if deviceSupportsLiDARMesh {
            if #available(iOS 13.4, *) {
                configuration.sceneReconstruction = .mesh
            }
        }
        if let planeDetectionConfig = arguments["planeDetectionConfig"] as? Int {
            switch planeDetectionConfig {
                case 1: 
                    configuration.planeDetection = .horizontal
                
                case 2: 
                    if #available(iOS 11.3, *) {
                        configuration.planeDetection = .vertical
                    }
                case 3: 
                    if #available(iOS 11.3, *) {
                        configuration.planeDetection = [.horizontal, .vertical]
                    }
                default: 
                    configuration.planeDetection = []
            }
        }

        // Set plane rendering options
        if let configShowPlanes = arguments["showPlanes"] as? Bool {
            showPlanes = configShowPlanes
            if (showPlanes){
                // Visualize currently tracked planes
                for plane in trackedPlanes.values {
                    plane.0.addChildNode(plane.1)
                }
            } else {
                // Remove currently visualized planes
                for plane in trackedPlanes.values {
                    plane.1.removeFromParentNode()
                }
            }
        }
        if let configCustomPlaneTexturePath = arguments["customPlaneTexturePath"] as? String {
            customPlaneTexturePath = configCustomPlaneTexturePath
        }

        // Set debug options
        var debugOptions = ARSCNDebugOptions().rawValue
        if let showFeaturePoints = arguments["showFeaturePoints"] as? Bool {
            if (showFeaturePoints) {
                debugOptions |= ARSCNDebugOptions.showFeaturePoints.rawValue
            }
        }
        if let showWorldOrigin = arguments["showWorldOrigin"] as? Bool {
            if (showWorldOrigin) {
                debugOptions |= ARSCNDebugOptions.showWorldOrigin.rawValue
            }
        }
        self.sceneView.debugOptions = ARSCNDebugOptions(rawValue: debugOptions)
        
        if let configHandleTaps = arguments["handleTaps"] as? Bool {
            if (configHandleTaps){
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                tapGestureRecognizer.delegate = self
                self.sceneView.gestureRecognizers?.append(tapGestureRecognizer)
            }
        }

        if let configHandlePans = arguments["handlePans"] as? Bool {
            if (configHandlePans){
                let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                panGestureRecognizer.maximumNumberOfTouches = 1
                panGestureRecognizer.delegate = self
                self.panGestureRecognizer = panGestureRecognizer
                self.sceneView.gestureRecognizers?.append(panGestureRecognizer)
            }
        }
        
        if let configHandleRotation = arguments["handleRotation"] as? Bool {
            if (configHandleRotation){
                let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
                rotationGestureRecognizer.delegate = self
                self.rotationGestureRecognizer = rotationGestureRecognizer
                self.sceneView.gestureRecognizers?.append(rotationGestureRecognizer)
            }
        }
        
        // Add coaching view
        if let configAutoHideCoachingOverlay = arguments["autoHideCoachingOverlay"] as? Bool {
            autoHideCoachingOverlay = configAutoHideCoachingOverlay
        }
        if let configShowAnimatedGuide = arguments["showAnimatedGuide"] as? Bool {
            if configShowAnimatedGuide {
                if self.sceneView.superview != nil && self.coachingView.superview == nil {
                    self.sceneView.addSubview(self.coachingView)
        //            self.coachingView.translatesAutoresizingMaskIntoConstraints = false
                    self.coachingView.autoresizingMask = [
                          .flexibleWidth, .flexibleHeight
                        ]
                    self.coachingView.session = self.sceneView.session
                    self.coachingView.activatesAutomatically = true
                    if configuration.planeDetection == .horizontal {
                        self.coachingView.goal = .horizontalPlane
                    }else{
                        self.coachingView.goal = .verticalPlane
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.coachingView.removeFromSuperview()
                }
            }
        }
    
        // Configure image tracking
        applyImageTrackingSettings(
            trackingImagePaths: arguments["trackingImagePaths"] as? [String],
            continuous: arguments["continuousImageTracking"] as? Bool,
            intervalMs: arguments["imageTrackingUpdateIntervalMs"] as? NSNumber,
            runSession: true
        )

        // Apply lighting multiplier if provided
        applyLightIntensityMultiplier(arguments["lightIntensityMultiplier"] as? NSNumber)
    
        // Update session configuration
        self.sceneView.session.run(configuration)
        result(nil)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor{
            let plane = modelBuilder.makePlane(anchor: planeAnchor, flutterAssetFile: customPlaneTexturePath)
            trackedPlanes[anchor.identifier] = (node, plane)
            if (showPlanes) {
                node.addChildNode(plane)
            }
            reportPlaneDetectedIfNeeded(planeAnchor: planeAnchor)
            dismissCoachingOverlayIfNeeded()
        } else if isPlacementAnchor(anchor) {
            ensureShadowFloor(on: anchor, anchorNode: node)
            if let pending = pendingAnchorAttachments.removeValue(forKey: anchor.identifier) {
                attachFurnitureNode(pending.0, to: node)
                flutterNodeNames.insert(pending.1)
                pending.2(true)
            }
        }
        
        // Handle image anchors - store the anchor node for later use
        if let imageAnchor = anchor as? ARImageAnchor {
            // Store the image anchor for potential node attachment
            if let imageName = imageAnchor.referenceImage.name {
                anchorCollection["__image_\(imageName)"] = imageAnchor
            }
            dismissCoachingOverlayIfNeeded()
            handleImageDetection(imageAnchor: imageAnchor)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor, let plane = trackedPlanes[anchor.identifier] {
            modelBuilder.updatePlaneNode(planeNode: plane.1, anchor: planeAnchor)
            reportPlaneDetectedIfNeeded(planeAnchor: planeAnchor)
            dismissCoachingOverlayIfNeeded()
        }

        if continuousImageTracking, let imageAnchor = anchor as? ARImageAnchor {
            let imageName = imageAnchor.referenceImage.name ?? "unknown"
            let now = Date().timeIntervalSince1970
            let lastUpdate = lastImageUpdateTime[imageName] ?? 0
            if now - lastUpdate >= imageTrackingUpdateInterval {
                lastImageUpdateTime[imageName] = now
                // Update the stored anchor with the latest position
                anchorCollection["__image_\(imageName)"] = imageAnchor
                handleImageDetection(imageAnchor: imageAnchor)
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        trackedPlanes.removeValue(forKey: anchor.identifier)

        if let imageAnchor = anchor as? ARImageAnchor {
            let imageName = imageAnchor.referenceImage.name ?? "unknown"
            lastImageUpdateTime.removeValue(forKey: imageName)
            anchorCollection.removeValue(forKey: "__image_\(imageName)")
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if (arcoreMode) {
            do {
                try arcoreSession!.update(frame)
            } catch {
                print(error)
            }
        }
        if let lightEstimate = frame.lightEstimate {
            applyLightEstimate(lightEstimate)
        }
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        let stateString: String
        var reasonString = "NONE"
        switch camera.trackingState {
        case .normal:
            stateString = "TRACKING"
        case .notAvailable:
            stateString = "NOT_AVAILABLE"
        case .limited(let reason):
            stateString = "LIMITED"
            switch reason {
            case .initializing:
                reasonString = "INITIALIZING"
            case .excessiveMotion:
                reasonString = "EXCESSIVE_MOTION"
            case .insufficientFeatures:
                reasonString = "INSUFFICIENT_FEATURES"
            case .relocalizing:
                reasonString = "RELOCALIZING"
            @unknown default:
                reasonString = "NONE"
            }
        @unknown default:
            stateString = "NOT_AVAILABLE"
        }
        DispatchQueue.main.async {
            self.sessionManagerChannel.invokeMethod(
                "onTrackingState",
                arguments: [
                    "state": stateString,
                    "reason": reasonString,
                ]
            )
        }
    }

    private func completeNodeAdd(name: String, promise: @escaping (Result<Bool, Never>) -> Void) {
        flutterNodeNames.insert(name)
        promise(.success(true))
    }

    func addNode(dict_node: Dictionary<String, Any>, dict_anchor: Dictionary<String, Any>? = nil) -> Future<Bool, Never> {
        return Future {promise in
            let nodeName = dict_node["name"] as! String
            let perNodeTargetHeight: Float? = {
                guard let value = dict_node["targetHeightMeters"] as? NSNumber else { return nil }
                let meters = value.floatValue
                return meters > 0 ? meters : nil
            }()
            
            switch (dict_node["type"] as! Int) {
                case 0: // GLTF2 Model from Flutter asset folder
                    // Get path to given Flutter asset
                    let key = FlutterDartProject.lookupKey(forAsset: dict_node["uri"] as! String)
                    print("iOS: Adding GLTF2 node from asset: \(dict_node["uri"] as! String)")
                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromGltf(name: dict_node["name"] as! String, modelPath: key, transformation: dict_node["transformation"] as? Array<NSNumber>, perNodeTargetHeightMeters: perNodeTargetHeight) {
                        print("iOS: Node created successfully: \(dict_node["name"] as! String)")
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    self.attachNodeToPlaneAnchor(node, anchorName: anchorName, nodeName: nodeName, promise: promise)
                                default:
                                    print("iOS: Unknown anchor type: \(anchorType)")
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
                            self.sceneView.scene.rootNode.addChildNode(node)
                            self.completeNodeAdd(name: nodeName, promise: promise)
                        }
                    } else {
                        print("iOS: Failed to create node from GLTF")
                        self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])
                        promise(.success(false))
                    }
                    break
                case 1: // GLB Model from Flutter asset folder
                    // Get path to given Flutter asset
                    let key = FlutterDartProject.lookupKey(forAsset: dict_node["uri"] as! String)
                    print("iOS: Adding GLB node from asset: \(dict_node["uri"] as! String)")
                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromGLB(name: dict_node["name"] as! String, modelPath: key, transformation: dict_node["transformation"] as? Array<NSNumber>, perNodeTargetHeightMeters: perNodeTargetHeight) {
                        print("iOS: Node created successfully: \(dict_node["name"] as! String)")
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    self.attachNodeToPlaneAnchor(node, anchorName: anchorName, nodeName: nodeName, promise: promise)
                                default:
                                    print("iOS: Unknown anchor type: \(anchorType)")
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
                            self.sceneView.scene.rootNode.addChildNode(node)
                            print("iOS: Node attached to scene root")
                            self.completeNodeAdd(name: nodeName, promise: promise)
                        }
                    } else {
                        print("iOS: Failed to create node from GLB")
                        self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])
                        promise(.success(false))
                    }
                    break
                case 2: // GLB Model from the web
                    // Add object to scene
                    self.modelBuilder.makeNodeFromWebGlb(name: dict_node["name"] as! String, modelURL: dict_node["uri"] as! String, transformation: dict_node["transformation"] as? Array<NSNumber>, perNodeTargetHeightMeters: perNodeTargetHeight)
                    .sink(receiveCompletion: {
                                    completion in print("Async Model Downloading Task completed: ", completion)
                    }, receiveValue: { val in
                        if let node: SCNNode = val {
                            if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                                switch anchorType{
                                    case 0: //PlaneAnchor
                                        self.attachNodeToPlaneAnchor(node, anchorName: anchorName, nodeName: nodeName, promise: promise)
                                    default:
                                        promise(.success(false))
                                    }
                                
                            } else {
                                // Attach to top-level node of the scene
                                self.sceneView.scene.rootNode.addChildNode(node)
                                self.completeNodeAdd(name: nodeName, promise: promise)
                            }
                        } else {
                            self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["name"] as! String)"])
                            promise(.success(false))
                        }
                    }).store(in: &self.cancellableCollection)
                    break
                case 3: // GLB Model from the app's documents folder
                    // Get path to given file system asset
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let documentsDirectory = paths[0]
                    let targetPath = documentsDirectory.appendingPathComponent(dict_node["uri"] as! String).path
 
                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromFileSystemGLB(name: dict_node["name"] as! String, modelPath: targetPath, transformation: dict_node["transformation"] as? Array<NSNumber>, perNodeTargetHeightMeters: perNodeTargetHeight) {
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    self.attachNodeToPlaneAnchor(node, anchorName: anchorName, nodeName: nodeName, promise: promise)
                                default:
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
                            self.sceneView.scene.rootNode.addChildNode(node)
                            self.completeNodeAdd(name: nodeName, promise: promise)
                        }
                    } else {
                        self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])
                        promise(.success(false))
                    }
                    break
                case 4: //fileSystemAppFolderGLTF2
                    // Get path to given file system asset
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let documentsDirectory = paths[0]
                    let targetPath = documentsDirectory.appendingPathComponent(dict_node["uri"] as! String).path

                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromFileSystemGltf(name: dict_node["name"] as! String, modelPath: targetPath, transformation: dict_node["transformation"] as? Array<NSNumber>, perNodeTargetHeightMeters: perNodeTargetHeight) {
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    self.attachNodeToPlaneAnchor(node, anchorName: anchorName, nodeName: nodeName, promise: promise)
                                default:
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
                            self.sceneView.scene.rootNode.addChildNode(node)
                            self.completeNodeAdd(name: nodeName, promise: promise)
                        }
                    } else {
                        self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])
                        promise(.success(false))
                    }
                    break
                default:
                    promise(.success(false))
            }
            
        }
    }
    
    func transformNode(name: String, transform: Array<NSNumber>) {
        let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true)
        node?.transform = deserializeMatrix4(transform)
        if let node {
            updateShadowFrustum(for: node)
        }
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        let touchLocation = recognizer.location(in: sceneView)
    
        let allHitResults = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.closest.rawValue])
        // Because 3D model loading can lead to composed nodes, we have to traverse through a node's parent until the parent node with the name assigned by the Flutter API is found
        let nodeHitResults: Array<String> = allHitResults.compactMap { nearestFlutterManagedNode(node: $0.node)?.name }
        if (nodeHitResults.count != 0) {
            self.objectManagerChannel.invokeMethod("onNodeTap", arguments: Array(Set(nodeHitResults))) // Chaining of Array and Set is used to remove duplicates
            return
        }
            
        let planeTypes: ARHitTestResult.ResultType
        if #available(iOS 11.3, *){
            planeTypes = ARHitTestResult.ResultType([.existingPlaneUsingGeometry, .featurePoint])
        }else {
            planeTypes = ARHitTestResult.ResultType([.existingPlaneUsingExtent, .featurePoint])
        }
        
        let planeAndPointHitResults = sceneView.hitTest(touchLocation, types: planeTypes)
        
        // store the alignment of the tapped plane anchor so we can refer to is later when transforming the node
        if planeAndPointHitResults.count > 0, let hitAnchor = planeAndPointHitResults.first?.anchor as? ARPlaneAnchor {
            self.tappedPlaneAnchorAlignment = hitAnchor.alignment
        }
            
        let serializedPlaneAndPointHitResults = planeAndPointHitResults.map{serializeHitResult($0)}
        if (serializedPlaneAndPointHitResults.count != 0) {
            self.sessionManagerChannel.invokeMethod("onPlaneOrPointTap", arguments: serializedPlaneAndPointHitResults)
        }
    }

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }

        // State Begins
        if recognizer.state == UIGestureRecognizer.State.began
        {
            panStartLocation = recognizer.location(in: sceneView)
            if let startLocation = panStartLocation {
                let allHitResults = sceneView.hitTest(startLocation, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.closest.rawValue])
                // Because 3D model loading can lead to composed nodes, we have to traverse through a node's parent until the parent node with the name assigned by the Flutter API is found
                let nodeHitResults: Array<String> = allHitResults.compactMap {
                    if let nearestNode = nearestFlutterManagedNode(node: $0.node) {
                        panningNode = nearestNode
                        return nearestNode.name
                    }else{
                        return nil
                    }
                }
                if (nodeHitResults.count != 0 && panningNode != nil) {
                    panningNodeCurrentWorldLocation = panningNode!.worldPosition
                    lastPanNotifiedTransform = nil
                    self.objectManagerChannel.invokeMethod("onPanStart", arguments: panningNode!.name) // Chaining of Array and Set is used to remove duplicates
                    return
                }
                if let nearestNode = nearestFlutterManagedNode(to: startLocation, in: sceneView) {
                    panningNode = nearestNode
                    panningNodeCurrentWorldLocation = nearestNode.worldPosition
                    lastPanNotifiedTransform = nil
                    self.objectManagerChannel.invokeMethod("onPanStart", arguments: nearestNode.name)
                    return
                }
            }
        }
        // State Changes
        if(recognizer.state == UIGestureRecognizer.State.changed)
        {
            // the velocity of the gesture is how fast it is moving. This can be used to translate the position of the node.
            panCurrentVelocity = recognizer.velocity(in: sceneView)
            panCurrentLocation = recognizer.location(in: sceneView)
            panCurrentTranslation = recognizer.translation(in: sceneView)

            if let panLoc = panCurrentLocation, let panNode = panningNode {
                if let targetWorld = computeDragWorldPosition(screenPoint: panLoc, panNode: panNode) {
                    applyDragWorldPosition(targetWorld, to: panNode, smooth: true)
                    notifyPanChangeIfTransformChanged(panNode)
                }
            }
        }
        // State Ended
        if(recognizer.state == UIGestureRecognizer.State.ended)
        {
            // kill variables
            panStartLocation = nil
            panCurrentLocation = nil
            lastPanNotifiedTransform = nil
            self.objectManagerChannel.invokeMethod("onPanEnd", arguments: serializeLocalTransformation(node: panningNode))
            panningNode = nil
        }
    }
    
    @objc func handleRotation(_ recognizer: UIRotationGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }

        if recognizer.state == UIGestureRecognizer.State.began {
            cancelActivePanIfNeeded()
            rotationStartLocation = recognizer.location(in: sceneView)
            lastRotationRadians = recognizer.rotation

            guard let startLocation = rotationStartLocation else { return }
            rotatingNode = resolveRotationNode(at: startLocation, in: sceneView)
            if let node = rotatingNode {
                self.objectManagerChannel.invokeMethod("onRotationStart", arguments: node.name)
            }
            return
        }

        if recognizer.state == UIGestureRecognizer.State.changed {
            guard let rotateNode = rotatingNode else { return }

            let currentRotation = recognizer.rotation
            let delta = Float(currentRotation - lastRotationRadians)
            lastRotationRadians = currentRotation

            applyRotationDelta(to: rotateNode, deltaRadians: delta)
            self.objectManagerChannel.invokeMethod("onRotationChange", arguments: rotateNode.name)
            return
        }

        if recognizer.state == UIGestureRecognizer.State.ended ||
            recognizer.state == UIGestureRecognizer.State.cancelled ||
            recognizer.state == UIGestureRecognizer.State.failed {
            if let rotateNode = rotatingNode {
                updateShadowFrustum(for: rotateNode)
                self.objectManagerChannel.invokeMethod(
                    "onRotationEnd",
                    arguments: serializeLocalTransformation(node: rotateNode)
                )
            }
            rotationStartLocation = nil
            rotatingNode = nil
            lastRotationRadians = 0
        }
    }

    private static let rotationSensitivity: Float = 0.85
    private static let rotationDeadZoneRadians: Float = 0.004
    private static let rotationHitMaxHorizontalDistanceM: Float = 0.8
    private static let rotationScreenHitRadiusPx: CGFloat = 280

    private func resolveRotationNode(at location: CGPoint, in sceneView: ARSCNView) -> SCNNode? {
        let allHitResults = sceneView.hitTest(
            location,
            options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue]
        )
        for result in allHitResults {
            if let nearestNode = nearestFlutterManagedNode(node: result.node) {
                return nearestNode
            }
        }

        return nearestFlutterManagedNode(to: location, in: sceneView)
    }

    private func applyRotationDelta(to node: SCNNode, deltaRadians: Float) {
        guard abs(deltaRadians) >= Self.rotationDeadZoneRadians else { return }
        applyImmediateRotation(to: node, deltaRadians: deltaRadians * Self.rotationSensitivity)
    }

    private func applyImmediateRotation(to node: SCNNode, deltaRadians: Float) {
        if tappedPlaneAnchorAlignment == .horizontal {
            node.eulerAngles.y += deltaRadians
        } else {
            node.eulerAngles.z += deltaRadians
        }
    }

    private func cancelActivePanIfNeeded() {
        if panningNode != nil {
            self.objectManagerChannel.invokeMethod(
                "onPanEnd",
                arguments: serializeLocalTransformation(node: panningNode)
            )
        }
        panningNode = nil
        panStartLocation = nil
        panCurrentLocation = nil
        panCurrentVelocity = nil
        panCurrentTranslation = nil
        panningNodeCurrentWorldLocation = nil
        lastPanNotifiedTransform = nil
        if let panGestureRecognizer = panGestureRecognizer {
            panGestureRecognizer.isEnabled = false
            panGestureRecognizer.isEnabled = true
        }
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        let isPanRotationPair =
            (gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIRotationGestureRecognizer) ||
            (gestureRecognizer is UIRotationGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer)
        return !isPanRotationPair
    }

    // Recursive helper function to traverse a node's parents until a Flutter-managed node is found
    func nearestFlutterManagedNode(node: SCNNode?) -> SCNNode? {
        var current = node
        while let candidate = current {
            if let name = candidate.name, flutterNodeNames.contains(name) {
                return candidate
            }
            current = candidate.parent
        }
        return nil
    }

    /// When mesh hit-testing misses, pick the Flutter-managed node nearest the
    /// touch in screen space (floor ray is only a fallback). Screen-first avoids
    /// the previous chair stealing the first gesture after switching targets.
    func nearestFlutterManagedNode(to location: CGPoint, in sceneView: ARSCNView) -> SCNNode? {
        let managedNodes: [SCNNode] = flutterNodeNames.compactMap { name in
            sceneView.scene.rootNode.childNode(withName: name, recursively: true)
        }
        guard !managedNodes.isEmpty else { return nil }

        var nearestScreen: SCNNode?
        var minScreenDist = CGFloat.greatestFiniteMagnitude
        let maxScreenSq = Self.rotationScreenHitRadiusPx * Self.rotationScreenHitRadiusPx
        for node in managedNodes {
            let dist = minScreenDistanceSquared(to: location, node: node, in: sceneView)
            if dist <= maxScreenSq && dist < minScreenDist {
                minScreenDist = dist
                nearestScreen = node
            }
        }
        if let nearestScreen { return nearestScreen }

        if let query = sceneView.raycastQuery(
            from: location,
            allowing: .estimatedPlane,
            alignment: .horizontal
        ),
           let raycast = sceneView.session.raycast(query).first {
            let hitX = raycast.worldTransform.columns.3.x
            let hitZ = raycast.worldTransform.columns.3.z
            var nearest: SCNNode?
            var minDist = Float.greatestFiniteMagnitude
            let maxDistSq =
                Self.rotationHitMaxHorizontalDistanceM * Self.rotationHitMaxHorizontalDistanceM
            for node in managedNodes {
                let pos = node.worldPosition
                let dx = hitX - pos.x
                let dz = hitZ - pos.z
                let dist = dx * dx + dz * dz
                if dist <= maxDistSq && dist < minDist {
                    minDist = dist
                    nearest = node
                }
            }
            if let nearest { return nearest }
        }

        return nil
    }

    private func minScreenDistanceSquared(
        to location: CGPoint,
        node: SCNNode,
        in sceneView: ARSCNView
    ) -> CGFloat {
        let (minB, maxB) = node.boundingBox
        let height = max(0.1, maxB.y - minB.y)
        let base = node.worldPosition
        let samples: [SCNVector3] = [
            base,
            SCNVector3(base.x, base.y + height * 0.45, base.z),
            SCNVector3(base.x, base.y + height * 0.85, base.z),
        ]
        var minDist = CGFloat.greatestFiniteMagnitude
        for sample in samples {
            let projected = sceneView.projectPoint(sample)
            guard projected.z >= 0 && projected.z <= 1 else { continue }
            let dx = CGFloat(projected.x) - location.x
            let dy = CGFloat(projected.y) - location.y
            let dist = dx * dx + dy * dy
            if dist < minDist {
                minDist = dist
            }
        }
        return minDist
    }

    func singleFlutterManagedNode(in sceneView: ARSCNView) -> SCNNode? {
        guard flutterNodeNames.count == 1, let name = flutterNodeNames.first else {
            return nil
        }
        return sceneView.scene.rootNode.childNode(withName: name, recursively: true)
    }

    // MARK: - Floor reference, shadow catcher, drag validation

    private func scnMatrix4ToSimd(_ matrix: SCNMatrix4) -> simd_float4x4 {
        return simd_float4x4(
            SIMD4<Float>(matrix.m11, matrix.m12, matrix.m13, matrix.m14),
            SIMD4<Float>(matrix.m21, matrix.m22, matrix.m23, matrix.m24),
            SIMD4<Float>(matrix.m31, matrix.m32, matrix.m33, matrix.m34),
            SIMD4<Float>(matrix.m41, matrix.m42, matrix.m43, matrix.m44)
        )
    }

    private func simdMatrix4ToSimdTransform(_ node: SCNNode) -> simd_float4x4 {
        return scnMatrix4ToSimd(node.transform)
    }

    private func transformsApproximatelyEqual(
        _ a: simd_float4x4,
        _ b: simd_float4x4,
        epsilon: Float = IosARView.transformEpsilon
    ) -> Bool {
        let av = [a.columns.0, a.columns.1, a.columns.2, a.columns.3].flatMap { [$0.x, $0.y, $0.z, $0.w] }
        let bv = [b.columns.0, b.columns.1, b.columns.2, b.columns.3].flatMap { [$0.x, $0.y, $0.z, $0.w] }
        for i in 0..<16 {
            if abs(av[i] - bv[i]) > epsilon { return false }
        }
        return true
    }

    private func setReferenceFloorFromPlacement(transform: Array<NSNumber>) {
        let matrix = scnMatrix4ToSimd(deserializeMatrix4(transform))
        referenceFloorY = matrix.columns.3.y
        placementInteriorPose = matrix
    }

    private func clearReferenceFloorIfNeeded() {
        guard anchorCollection.isEmpty else { return }
        referenceFloorY = nil
        placementInteriorPose = nil
        removeShadowFloor()
    }

    private func ensureShadowFloor(on anchor: ARAnchor, anchorNode: SCNNode) {
        guard shadowFloorNode == nil else { return }

        let floor = SCNFloor()
        floor.reflectivity = 0
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.lightingModel = .constant
        material.writesToDepthBuffer = false
        material.readsFromDepthBuffer = true
        material.colorBufferWriteMask = []
        floor.materials = [material]

        let floorNode = SCNNode(geometry: floor)
        floorNode.castsShadow = false
        floorNode.renderingOrder = -100
        anchorNode.addChildNode(floorNode)
        shadowFloorNode = floorNode
    }

    private func updateShadowFrustum(for node: SCNNode) {
        trackedFurnitureNode = node
        let (minV, maxV) = node.boundingBox
        let radius = max(maxV.x - minV.x, maxV.z - minV.z, maxV.y - minV.y) / 2
        directionalLightNode?.light?.orthographicScale = CGFloat(max(radius * 3, 1.0))
        repositionDirectionalLight()
    }

    private func attachFurnitureNode(_ node: SCNNode, to anchorNode: SCNNode) {
        anchorNode.addChildNode(node)
        updateShadowFrustum(for: node)
    }

    private func applyDepthOcclusionEnabled(_ enabled: Bool) {
        depthOcclusionEnabled = enabled
        let shouldOcclude = enabled && hasDepthSemanticsEnabled()
        if #available(iOS 13.0, *) {
            applyVirtualContentOcclusion(shouldOcclude)
        }
    }

    @available(iOS 13.0, *)
    private func applyVirtualContentOcclusion(_ enabled: Bool) {
        // Property exists on ARSCNView at runtime on device builds; guard via selector for SDK variance.
        let key = "automaticallyOccludesVirtualContent"
        guard sceneView.responds(to: NSSelectorFromString("setAutomaticallyOccludesVirtualContent:")) else {
            print("iOS: automaticallyOccludesVirtualContent unavailable on this SDK build")
            return
        }
        sceneView.setValue(enabled, forKey: key)
    }

    private func hasDepthSemanticsEnabled() -> Bool {
        guard let config = sceneView.session.configuration as? ARWorldTrackingConfiguration else {
            return false
        }
        if #available(iOS 14.0, *) {
            if config.frameSemantics.contains(.smoothedSceneDepth) {
                return true
            }
        }
        if #available(iOS 13.0, *) {
            if config.frameSemantics.contains(.sceneDepth) {
                return true
            }
            if config.frameSemantics.contains(.personSegmentationWithDepth) {
                return true
            }
        }
        return false
    }

    private func isPlacementAnchor(_ anchor: ARAnchor) -> Bool {
        return anchorCollection.values.contains { $0.identifier == anchor.identifier }
    }

    private func attachNodeToPlaneAnchor(
        _ node: SCNNode,
        anchorName: String,
        nodeName: String,
        promise: @escaping (Result<Bool, Never>) -> Void
    ) {
        guard let anchor = anchorCollection[anchorName] else {
            print("iOS: Failed to find anchor: \(anchorName)")
            promise(.success(false))
            return
        }
        if let anchorNode = sceneView.node(for: anchor) {
            attachFurnitureNode(node, to: anchorNode)
            completeNodeAdd(name: nodeName, promise: promise)
        } else {
            pendingAnchorAttachments[anchor.identifier] = (node, nodeName, { success in
                promise(.success(success))
            })
        }
    }

    private func removeShadowFloor() {
        shadowFloorNode?.removeFromParentNode()
        shadowFloorNode = nil
    }

    private func trackedPlaneAnchors() -> [ARPlaneAnchor] {
        guard let anchors = sceneView.session.currentFrame?.anchors else { return [] }
        return anchors.compactMap { $0 as? ARPlaneAnchor }
    }

    private func isTrackingHorizontalPlane(_ anchor: ARPlaneAnchor) -> Bool {
        return anchor.alignment == .horizontal
    }

    private func worldPointToPlaneLocal(_ point: SCNVector3, planeAnchor: ARPlaneAnchor) -> simd_float4 {
        let world = simd_float4(point.x, point.y, point.z, 1)
        return planeAnchor.transform.inverse * world
    }

    @available(iOS 11.3, *)
    private func boundaryVerticesArray(from geometry: ARPlaneGeometry) -> [SIMD3<Float>] {
        return geometry.boundaryVertices.map { SIMD3<Float>($0.x, $0.y, $0.z) }
    }

    private func isPointInPolygonXZ(x: Float, z: Float, vertices: [SIMD3<Float>], count: Int) -> Bool {
        guard count >= 3 else { return false }
        var inside = false
        var j = count - 1
        for i in 0..<count {
            let xi = vertices[i].x
            let zi = vertices[i].z
            let xj = vertices[j].x
            let zj = vertices[j].z
            let intersects = ((zi > z) != (zj > z)) &&
                (x < (xj - xi) * (z - zi) / (zj - zi + 1e-8) + xi)
            if intersects { inside = !inside }
            j = i
        }
        return inside
    }

    private func isPointInHorizontalPlaneAnchor(_ point: SCNVector3, planeAnchor: ARPlaneAnchor) -> Bool {
        guard planeAnchor.alignment == .horizontal else { return false }
        let local = worldPointToPlaneLocal(point, planeAnchor: planeAnchor)
        if #available(iOS 11.3, *) {
            let geometry = planeAnchor.geometry
            let vertices = boundaryVerticesArray(from: geometry)
            return isPointInPolygonXZ(
                x: local.x,
                z: local.z,
                vertices: vertices,
                count: vertices.count
            )
        }
        return abs(local.x) <= planeAnchor.extent.x / 2 &&
            abs(local.z) <= planeAnchor.extent.z / 2
    }

    private func distanceToPolygonEdge(_ point: SCNVector3, planeAnchor: ARPlaneAnchor) -> Float {
        guard planeAnchor.alignment == .horizontal else { return Float.greatestFiniteMagnitude }
        let local = worldPointToPlaneLocal(point, planeAnchor: planeAnchor)
        let px = local.x
        let pz = local.z

        if #available(iOS 11.3, *) {
            let geometry = planeAnchor.geometry
            let vertices = boundaryVerticesArray(from: geometry)
            let count = vertices.count
            guard count >= 2 else { return Float.greatestFiniteMagnitude }
            var minDist = Float.greatestFiniteMagnitude
            for i in 0..<count {
                let j = (i + 1) % count
                let x1 = vertices[i].x
                let z1 = vertices[i].z
                let x2 = vertices[j].x
                let z2 = vertices[j].z
                let dist = pointToSegmentDist(px, pz, x1, z1, x2, z2)
                if dist < minDist { minDist = dist }
            }
            return minDist
        }

        let halfX = planeAnchor.extent.x / 2
        let halfZ = planeAnchor.extent.z / 2
        let dx = max(abs(px) - halfX, 0)
        let dz = max(abs(pz) - halfZ, 0)
        return sqrt(dx * dx + dz * dz)
    }

    private func pointToSegmentDist(
        _ px: Float, _ pz: Float,
        _ x1: Float, _ z1: Float,
        _ x2: Float, _ z2: Float
    ) -> Float {
        let dx = x2 - x1
        let dz = z2 - z1
        let lenSq = dx * dx + dz * dz
        if lenSq < 1e-8 {
            let ex = px - x1
            let ez = pz - z1
            return sqrt(ex * ex + ez * ez)
        }
        var t = ((px - x1) * dx + (pz - z1) * dz) / lenSq
        t = max(0, min(1, t))
        let cx = x1 + t * dx
        let cz = z1 + t * dz
        let ex = px - cx
        let ez = pz - cz
        return sqrt(ex * ex + ez * ez)
    }

    private func planeHeightDeltaFromReference(_ planeAnchor: ARPlaneAnchor, referenceFloorY: Float) -> Float {
        return abs(planeAnchor.transform.columns.3.y - referenceFloorY)
    }

    private func snapWorldPositionToReferenceFloorY(_ point: SCNVector3, referenceFloorY: Float) -> SCNVector3 {
        return SCNVector3(point.x, referenceFloorY, point.z)
    }

    private func signedDistanceToPlaneNormal(_ point: SCNVector3, planeAnchor: ARPlaneAnchor) -> Float {
        let local = worldPointToPlaneLocal(point, planeAnchor: planeAnchor)
        switch planeAnchor.alignment {
        case .vertical:
            return local.z
        case .horizontal:
            return local.y
        @unknown default:
            return Float.greatestFiniteMagnitude
        }
    }

    private func hasTrackedVerticalWalls() -> Bool {
        return trackedPlaneAnchors().contains(where: {
            $0.alignment == .vertical
        })
    }

    private func countNearbyVerticalWalls(_ snapPoint: SCNVector3, referenceFloorY: Float) -> Int {
        var count = 0
        for wall in trackedPlaneAnchors() {
            guard wall.alignment == .vertical else { continue }
            if abs(snapPoint.y - referenceFloorY) > Self.maxDragPlaneHeightBandM { continue }
            if abs(signedDistanceToPlaneNormal(snapPoint, planeAnchor: wall)) < Self.wallCornerDetectRangeM {
                count += 1
            }
        }
        return count
    }

    private func requiredWallClearance(_ snapPoint: SCNVector3, referenceFloorY: Float) -> Float {
        return countNearbyVerticalWalls(snapPoint, referenceFloorY: referenceFloorY) >= 2
            ? Self.minWallClearanceCornerM
            : Self.minWallClearanceFaceM
    }

    private func findBestFloorPlaneForSnapPose(_ point: SCNVector3, referenceFloorY: Float) -> ARPlaneAnchor? {
        var bestPlane: ARPlaneAnchor?
        var bestHeightDelta = Float.greatestFiniteMagnitude
        for plane in trackedPlaneAnchors() {
            guard isTrackingHorizontalPlane(plane) else { continue }
            guard isPointInHorizontalPlaneAnchor(point, planeAnchor: plane) else { continue }
            let heightDelta = planeHeightDeltaFromReference(plane, referenceFloorY: referenceFloorY)
            if heightDelta < bestHeightDelta {
                bestHeightDelta = heightDelta
                bestPlane = plane
            }
        }
        return bestHeightDelta <= Self.maxDragPlaneHeightBandM ? bestPlane : nil
    }

    private func validateDragSnapPose(_ point: SCNVector3, referenceFloorY: Float) -> Bool {
        if abs(point.y - referenceFloorY) > Self.maxDragPlaneHeightBandM { return false }
        guard findBestFloorPlaneForSnapPose(point, referenceFloorY: referenceFloorY) != nil else {
            return false
        }

        if !hasTrackedVerticalWalls() {
            if let floorPlane = findBestFloorPlaneForSnapPose(point, referenceFloorY: referenceFloorY),
               distanceToPolygonEdge(point, planeAnchor: floorPlane) <= Self.minPlaneEdgeMarginM {
                return false
            }
            return true
        }

        guard let interiorPose = placementInteriorPose else { return true }
        let interiorPoint = SCNVector3(
            interiorPose.columns.3.x,
            interiorPose.columns.3.y,
            interiorPose.columns.3.z
        )
        let clearance = requiredWallClearance(point, referenceFloorY: referenceFloorY)

        for wall in trackedPlaneAnchors() {
            guard wall.alignment == .vertical else { continue }
            if abs(point.y - referenceFloorY) > Self.maxDragPlaneHeightBandM { continue }

            let snapDist = signedDistanceToPlaneNormal(point, planeAnchor: wall)
            let interiorDist = signedDistanceToPlaneNormal(interiorPoint, planeAnchor: wall)
            if snapDist * interiorDist < 0 { return false }
            if abs(snapDist) < clearance { return false }
        }
        return true
    }

    private func acceptDragSnapPose(_ point: SCNVector3, referenceFloorY: Float) -> SCNVector3? {
        let snapped = snapWorldPositionToReferenceFloorY(point, referenceFloorY: referenceFloorY)
        return validateDragSnapPose(snapped, referenceFloorY: referenceFloorY) ? snapped : nil
    }

    private func isElevationPlausible(rawHitY: Float, referenceFloorY: Float) -> Bool {
        return abs(rawHitY - referenceFloorY) <= Self.maxDragSurfaceElevationM
    }

    private func realWorldElevation(at screenPoint: CGPoint) -> Float? {
        guard let query = sceneView.raycastQuery(
            from: screenPoint,
            allowing: .estimatedPlane,
            alignment: .horizontal
        ) else { return nil }
        return sceneView.session.raycast(query).first?.worldTransform.columns.3.y
    }

    private func intersectScreenRayWithHorizontalPlane(screenPoint: CGPoint, planeY: Float) -> SCNVector3? {
        guard sceneView.bounds.height > 0 else { return nil }

        let near = sceneView.unprojectPoint(SCNVector3(
            Float(screenPoint.x),
            Float(screenPoint.y),
            0
        ))
        let far = sceneView.unprojectPoint(SCNVector3(
            Float(screenPoint.x),
            Float(screenPoint.y),
            1
        ))

        let dx = far.x - near.x
        let dy = far.y - near.y
        let dz = far.z - near.z
        if abs(dy) < 1e-6 { return nil }

        let t = (planeY - near.y) / dy
        if t < 0 { return nil }

        return SCNVector3(near.x + dx * t, planeY, near.z + dz * t)
    }

    private func pickBestDragRaycastHit(_ results: [ARRaycastResult], referenceFloorY: Float) -> ARRaycastResult? {
        struct Candidate {
            let hit: ARRaycastResult
            let planeHeightDelta: Float
            let edgeDist: Float
        }

        let candidates: [Candidate] = results.compactMap { result in
            guard let plane = result.anchor as? ARPlaneAnchor else { return nil }
            guard isTrackingHorizontalPlane(plane) else { return nil }
            let hitX = result.worldTransform.columns.3.x
            let hitY = result.worldTransform.columns.3.y
            let hitZ = result.worldTransform.columns.3.z
            let hitPoint = SCNVector3(hitX, hitY, hitZ)
            guard isPointInHorizontalPlaneAnchor(hitPoint, planeAnchor: plane) else { return nil }
            let snapped = snapWorldPositionToReferenceFloorY(hitPoint, referenceFloorY: referenceFloorY)
            guard isPointInHorizontalPlaneAnchor(snapped, planeAnchor: plane) else { return nil }
            guard validateDragSnapPose(snapped, referenceFloorY: referenceFloorY) else { return nil }
            return Candidate(
                hit: result,
                planeHeightDelta: planeHeightDeltaFromReference(plane, referenceFloorY: referenceFloorY),
                edgeDist: distanceToPolygonEdge(snapped, planeAnchor: plane)
            )
        }
        if candidates.isEmpty { return nil }

        let inBand = candidates.filter { $0.planeHeightDelta <= Self.maxDragPlaneHeightBandM }
        let pool = inBand.isEmpty ? [candidates.min(by: { $0.planeHeightDelta < $1.planeHeightDelta })!] : inBand
        return pool.max(by: {
            if $0.planeHeightDelta != $1.planeHeightDelta {
                return $0.planeHeightDelta < $1.planeHeightDelta
            }
            return $0.edgeDist < $1.edgeDist
        })?.hit
    }

    private func translationDeltaM(_ from: SCNVector3, _ to: SCNVector3) -> Float {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }

    private func finalizeDragWorldPosition(
        current: SCNVector3,
        target: SCNVector3,
        referenceFloorY: Float
    ) -> SCNVector3 {
        let snapped = snapWorldPositionToReferenceFloorY(target, referenceFloorY: referenceFloorY)
        let jumpM = translationDeltaM(current, snapped)
        if jumpM <= Self.maxDragJumpM { return snapped }

        let t = Self.maxDragJumpM / jumpM
        let clamped = SCNVector3(
            current.x + (snapped.x - current.x) * t,
            referenceFloorY,
            current.z + (snapped.z - current.z) * t
        )
        if validateDragSnapPose(clamped, referenceFloorY: referenceFloorY) {
            return clamped
        }
        return SCNVector3(current.x, referenceFloorY, current.z)
    }

    private func computeDragWorldPosition(screenPoint: CGPoint, panNode: SCNNode) -> SCNVector3? {
        let currentWorld = panNode.worldPosition

        guard let floorY = referenceFloorY else {
            guard let query = sceneView.raycastQuery(
                from: screenPoint,
                allowing: .estimatedPlane,
                alignment: .horizontal
            ) else { return nil }
            guard let result = sceneView.session.raycast(query).first else { return nil }
            return SCNVector3(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )
        }

        if let rayHit = intersectScreenRayWithHorizontalPlane(screenPoint: screenPoint, planeY: floorY) {
            let elevationOk = realWorldElevation(at: screenPoint)
                .map { isElevationPlausible(rawHitY: $0, referenceFloorY: floorY) } ?? true
            if elevationOk, let accepted = acceptDragSnapPose(rayHit, referenceFloorY: floorY) {
                return finalizeDragWorldPosition(current: currentWorld, target: accepted, referenceFloorY: floorY)
            }
        }

        if let query = sceneView.raycastQuery(
            from: screenPoint,
            allowing: .estimatedPlane,
            alignment: .horizontal
        ) {
            let results = sceneView.session.raycast(query)
            if let hit = pickBestDragRaycastHit(results, referenceFloorY: floorY) {
                let realHitY = hit.worldTransform.columns.3.y
                guard isElevationPlausible(rawHitY: realHitY, referenceFloorY: floorY) else {
                    return nil
                }
                let worldHit = SCNVector3(
                    hit.worldTransform.columns.3.x,
                    floorY,
                    hit.worldTransform.columns.3.z
                )
                if let accepted = acceptDragSnapPose(worldHit, referenceFloorY: floorY) {
                    return finalizeDragWorldPosition(
                        current: currentWorld,
                        target: accepted,
                        referenceFloorY: floorY
                    )
                }
            }
        }

        return nil
    }

    private func applyDragWorldPosition(_ targetWorld: SCNVector3, to panNode: SCNNode, smooth: Bool) {
        var tx = targetWorld.x
        var ty = targetWorld.y
        var tz = targetWorld.z
        if smooth {
            let current = panNode.worldPosition
            tx = current.x + (tx - current.x) * Self.dragSmoothFactor
            ty = current.y + (ty - current.y) * Self.dragSmoothFactor
            tz = current.z + (tz - current.z) * Self.dragSmoothFactor
        }

        let finalWorld = SCNVector3(tx, ty, tz)
        if let anchorNode = panNode.parent, anchorNode !== sceneView.scene.rootNode {
            let localHit = anchorNode.convertPosition(finalWorld, from: nil)
            panNode.position = SCNVector3(localHit.x, panNode.position.y, localHit.z)
        } else {
            panNode.worldPosition = finalWorld
        }
        updateShadowFrustum(for: panNode)
    }

    private func notifyPanChangeIfTransformChanged(_ node: SCNNode) {
        let current = simdMatrix4ToSimdTransform(node)
        if let last = lastPanNotifiedTransform,
           transformsApproximatelyEqual(last, current) {
            return
        }
        lastPanNotifiedTransform = current
        objectManagerChannel.invokeMethod("onPanChange", arguments: node.name)
    }

    func addPlaneAnchor(transform: Array<NSNumber>, name: String){
        setReferenceFloorFromPlacement(transform: transform)
        let arAnchor = ARAnchor(transform: scnMatrix4ToSimd(deserializeMatrix4(transform)))
        anchorCollection[name] = arAnchor
        sceneView.session.add(anchor: arAnchor)
    }
    
    func deleteAnchor(anchorName: String) {
        if let anchor = anchorCollection[anchorName]{
            // Delete all child nodes
            if var attachedNodes = sceneView.node(for: anchor)?.childNodes {
                attachedNodes.removeAll()
            }
            // Remove anchor
            sceneView.session.remove(anchor: anchor)
            // Update bookkeeping
            anchorCollection.removeValue(forKey: anchorName)
            clearReferenceFloorIfNeeded()
        }
    }
    
    private class cloudAnchorUploadedListener: CloudAnchorListener {
        private var parent: IosARView
        
        init(parent: IosARView) {
            self.parent = parent
        }
        
        func onCloudTaskComplete(anchorName: String?, anchor: GARAnchor?) {
            if let cloudState = anchor?.cloudState {
                if (cloudState == GARCloudAnchorState.success) {
                    var args = Dictionary<String, String?>()
                    args["name"] = anchorName
                    args["cloudanchorid"] = anchor?.cloudIdentifier
                    parent.anchorManagerChannel.invokeMethod("onCloudAnchorUploaded", arguments: args)
                } else {
                    print("Error uploading anchor, state: \(parent.decodeCloudAnchorState(state: cloudState))")
                    parent.sessionManagerChannel.invokeMethod("onError", arguments: ["Error uploading anchor, state: \(parent.decodeCloudAnchorState(state: cloudState))"])
                    return
                }
            }
        }
    }

    private class cloudAnchorDownloadedListener: CloudAnchorListener {
        private var parent: IosARView
        
        init(parent: IosARView) {
            self.parent = parent
        }
        
        func onCloudTaskComplete(anchorName: String?, anchor: GARAnchor?) {
            if let cloudState = anchor?.cloudState {
                if (cloudState == GARCloudAnchorState.success) {
                    let newAnchor = ARAnchor(transform: anchor!.transform)
                    // Register new anchor on the Flutter side of the plugin
                    parent.anchorManagerChannel.invokeMethod("onAnchorDownloadSuccess", arguments: serializeAnchor(anchor: newAnchor, anchorNode: nil, ganchor: anchor!, name: anchorName), result: { result in
                        if let anchorName = result as? String {
                            self.parent.sceneView.session.add(anchor: newAnchor)
                            self.parent.anchorCollection[anchorName] = newAnchor
                        } else {
                            self.parent.sessionManagerChannel.invokeMethod("onError", arguments: ["Error while registering downloaded anchor at the AR Flutter plugin"])
                        }

                    })
                } else {
                    print("Error downloading anchor, state \(cloudState)")
                    parent.sessionManagerChannel.invokeMethod("onError", arguments: ["Error downloading anchor, state \(cloudState)"])
                    return
                }
            }
        }
    }
    
    func decodeCloudAnchorState(state: GARCloudAnchorState) -> String {
        switch state {
        case .errorCloudIdNotFound:
            return "Cloud anchor id not found"
        case .errorHostingDatasetProcessingFailed:
            return "Dataset processing failed, feature map insufficient"
        case .errorHostingServiceUnavailable:
            return "Hosting service unavailable"
        case .errorInternal:
            return "Internal error"
        case .errorNotAuthorized:
            return "Authentication failed: Not Authorized"
        case .errorResolvingSdkVersionTooNew:
            return "Resolving Sdk version too new"
        case .errorResolvingSdkVersionTooOld:
            return "Resolving Sdk version too old"
        case .errorResourceExhausted:
            return " Resource exhausted"
        case .none:
            return "Empty state"
        case .taskInProgress:
            return "Task in progress"
        case .success:
            return "Success"
        case .errorServiceUnavailable:
            return "Cloud Anchor Service unavailable"
        case .errorResolvingLocalizationNoMatch:
            return "No match"
        @unknown default:
            return "Unknown"
        }
    }
    
    // MARK: - Image Tracking

    func applyImageTrackingSettings(
        trackingImagePaths: [String]?,
        continuous: Bool?,
        intervalMs: NSNumber?,
        runSession: Bool = true
    ) {
        if let continuous = continuous {
            continuousImageTracking = continuous
        }
        if let intervalMs = intervalMs {
            imageTrackingUpdateInterval = intervalMs.doubleValue / 1000.0
        }
        if let trackingImagePaths = trackingImagePaths {
            setupImageTrackingAsync(imagePaths: trackingImagePaths, runSession: runSession)
        }
    }
    
    private func imageCacheKey(_ imagePaths: [String]) -> String {
        return imagePaths.joined(separator: "|")
    }
    
    func setupImageTrackingAsync(imagePaths: [String], runSession: Bool) {
        let cacheKey = imageCacheKey(imagePaths)
        if let cachedImages = IosARView.cachedReferenceImages[cacheKey] {
            DispatchQueue.main.async {
                self.configuration.detectionImages = cachedImages
                if runSession {
                    self.sceneView.session.run(self.configuration)
                }
                self.sessionManagerChannel.invokeMethod(
                    "onImageTrackingConfigured",
                    arguments: ["success": true, "cached": true]
                )
            }
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            var referenceImages = Set<ARReferenceImage>()
            var success = true
            
            for imagePath in imagePaths {
                if let image = self.loadImageFromAssets(imagePath: imagePath) {
                    let imageName = URL(fileURLWithPath: imagePath).deletingPathExtension().lastPathComponent
                    
                    // Create ARReferenceImage with a default physical width (you may want to make this configurable)
                    let physicalWidth: Float = 0.2 // 20cm default width - adjust based on your actual printed image size
                    let referenceImage = ARReferenceImage(image.cgImage!, orientation: .up, physicalWidth: CGFloat(physicalWidth))
                    referenceImage.name = imageName
                    
                    referenceImages.insert(referenceImage)
                } else {
                    print("Failed to load image: \(imagePath)")
                    success = false
                }
            }
            
            DispatchQueue.main.async {
                IosARView.cachedReferenceImages[cacheKey] = referenceImages
                self.configuration.detectionImages = referenceImages
                if runSession {
                    self.sceneView.session.run(self.configuration)
                }
                self.sessionManagerChannel.invokeMethod(
                    "onImageTrackingConfigured",
                    arguments: ["success": success]
                )
            }
        }
    }

    func precompileImageTrackingDatabase(imagePaths: [String], completion: @escaping (Bool) -> Void) {
        let cacheKey = imageCacheKey(imagePaths)
        if IosARView.cachedReferenceImages[cacheKey] != nil {
            completion(true)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            var referenceImages = Set<ARReferenceImage>()
            var success = true

            for imagePath in imagePaths {
                if let image = self.loadImageFromAssets(imagePath: imagePath) {
                    let imageName = URL(fileURLWithPath: imagePath).deletingPathExtension().lastPathComponent
                    let physicalWidth: Float = 0.2
                    let referenceImage = ARReferenceImage(image.cgImage!, orientation: .up, physicalWidth: CGFloat(physicalWidth))
                    referenceImage.name = imageName
                    referenceImages.insert(referenceImage)
                } else {
                    print("Failed to load image: \(imagePath)")
                    success = false
                }
            }

            DispatchQueue.main.async {
                IosARView.cachedReferenceImages[cacheKey] = referenceImages
                completion(success)
            }
        }
    }
    
    func loadImageFromAssets(imagePath: String) -> UIImage? {
        let key = FlutterDartProject.lookupKey(forAsset: imagePath)
        if let directPath = Bundle.main.path(forResource: key, ofType: nil) {
            return UIImage(contentsOfFile: directPath)
        }
        if let flutterAssetsPath = Bundle.main.path(forResource: "flutter_assets/\(key)", ofType: nil) {
            return UIImage(contentsOfFile: flutterAssetsPath)
        }
        return nil
    }
    
    func handleImageDetection(imageAnchor: ARImageAnchor) {
        let imageName = imageAnchor.referenceImage.name ?? "unknown"
        let transformation = serializeMatrix(imageAnchor.transform)
        
        print("iOS: Image detected - \(imageName)")
        print("iOS: Transform: \(transformation)")
        dismissCoachingOverlayIfNeeded()
        
        let arguments: [String: Any] = [
            "imageName": imageName,
            "transformation": transformation
        ]
        
        DispatchQueue.main.async {
            self.sessionManagerChannel.invokeMethod("onImageDetected", arguments: arguments)
        }
    }

    private func reportPlaneDetectedIfNeeded(planeAnchor: ARPlaneAnchor) {
        guard !hasReportedPlaneDetection else { return }
        guard planeAnchor.alignment == .horizontal else { return }
        guard planeAnchor.extent.x >= 0.2 && planeAnchor.extent.z >= 0.2 else { return }
        hasReportedPlaneDetection = true
        DispatchQueue.main.async {
            self.sessionManagerChannel.invokeMethod("onPlaneDetected", arguments: nil)
        }
    }

    private func dismissCoachingOverlayIfNeeded() {
        guard autoHideCoachingOverlay else { return }
        guard !coachingOverlayDismissed else { return }
        coachingOverlayDismissed = true

        DispatchQueue.main.async {
            guard self.coachingView.superview != nil else { return }
            if #available(iOS 13.0, *) {
                if self.coachingView.isActive {
                    self.coachingView.setActive(false, animated: true)
                }
            }
            self.coachingView.activatesAutomatically = false
            self.coachingView.removeFromSuperview()
        }
    }
}

// ---------------------- ARCoachingOverlayViewDelegate ---------------------------------------

extension IosARView: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView){
        // use this delegate method to hide anything in the UI that could cover the coaching overlay view
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        // Reset the session.
        self.sceneView.session.run(configuration, options: [.resetTracking])
    }
}
