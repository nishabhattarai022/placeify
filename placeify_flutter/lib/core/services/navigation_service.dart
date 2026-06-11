import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class NavigationService {
  static void go(BuildContext context, String location) {
    context.go(location);
  }

  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}
