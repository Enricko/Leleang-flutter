import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Component {
  
}
// MyCutomScrollBehavior
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}