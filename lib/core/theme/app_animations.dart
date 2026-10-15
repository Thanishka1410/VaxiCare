import 'package:flutter/material.dart';

/// Centralized animation durations and easing curves for VaxiCare
class AppAnimations {
  // Durations (180ms - 450ms as per design guidelines)
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration long = Duration(milliseconds: 450);
  static const Duration extended = Duration(milliseconds: 650);

  // Easing curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve smoothInOut = Curves.easeInOut;
  static const Curve standard = Curves.fastOutSlowIn;
  static const Curve subtleSpring = Curves.easeOutBack;

  // Stagger delays
  static const Duration staggerStep = Duration(milliseconds: 70);
}
