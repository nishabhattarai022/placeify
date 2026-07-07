import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;

bool get isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

bool get isMobilePlatform => isAndroid || isIOS;

bool get isDesktopPlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS);

String get loopbackHost => isAndroid ? '10.0.2.2' : 'localhost';
