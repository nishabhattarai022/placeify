/// Copy for the vendor 3D model builder workflow.
abstract final class Vendor3dBuilderStrings {
  static const moduleTitle = 'Build 3D Module';
  static const moduleSubtitle =
      'Turn product photos into AR-ready furniture models';
  static const moduleCta = 'Open 3D Studio';

  static const screenTitle = 'Build 3D Model';
  static const screenSubtitle =
      'Capture angles, confirm dimensions, and publish an AR preview';

  static const productSectionTitle = 'Select product';
  static const productSectionHint =
      'Choose the listing you want to generate a 3D model for.';

  static const captureSectionTitle = 'Reference photos';
  static const captureSectionHint =
      'Upload front, left, back, and right photos. Good lighting improves model accuracy.';

  static const dimensionsSectionTitle = 'Confirm dimensions';
  static const dimensionsSectionHint =
      'We use your catalog measurements to scale the generated model.';

  static const generateSectionTitle = 'Generate model';
  static const generateSectionHint =
      'Placeify reconstructs a lightweight GLB preview customers can place in AR.';

  static const doneCta = 'Done';
  static const generateCta = 'Generate 3D model';
  static const regenerateCta = 'Regenerate model';

  static const modelReady = '3D model ready';
  static const modelQueued =
      'Building 3D in the background. You can leave this screen — we\'ll notify you when it\'s ready.';
  static const modelPreparing =
      'Starting 3D build… Almost done — then you can leave and we\'ll finish in the background.';
  static const modelProcessing =
      'Generating model… This usually takes 1–3 minutes.';
  static const modelFailed =
      'Generation failed. Check your photos and try again.';

  static const noProducts = 'Add a product before building a 3D model.';
  static const selectProductFirst = 'Select a product to continue.';
  static const addPhotosFirst =
      'Add four reference photos: front, left, back, and right.';
  static const dimensionsRequired = 'Enter width, depth, and height first.';

  static String productsNeedingModels(int count) {
    if (count <= 0) return 'All products have AR previews';
    if (count == 1) return '1 product needs a 3D model';
    return '$count products need 3D models';
  }

  static String readyCount(int ready, int total) =>
      '$ready of $total products AR-ready';
}
