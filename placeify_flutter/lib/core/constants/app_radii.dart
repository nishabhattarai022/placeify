import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const BorderRadius sm = BorderRadius.all(Radius.circular(10));
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
  static const BorderRadius phone = BorderRadius.all(Radius.circular(50));

  static const Radius rSm = Radius.circular(10);
  static const Radius rMd = Radius.circular(16);
  static const Radius rLg = Radius.circular(20);
  static const Radius rPill = Radius.circular(999);
  static const Radius rPhone = Radius.circular(50);
}
