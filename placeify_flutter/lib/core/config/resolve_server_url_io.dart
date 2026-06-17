import 'dart:io';

bool get isAndroid => Platform.isAndroid;

bool get isIOS => Platform.isIOS;

bool get isMobilePlatform => Platform.isAndroid || Platform.isIOS;

bool get isDesktopPlatform =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

String get loopbackHost => Platform.isAndroid ? '10.0.2.2' : 'localhost';
