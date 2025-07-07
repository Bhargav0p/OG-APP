import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'demo.dart';
import 'env.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  static String _pkg = "constellations_list";
  static String? get pkg => Env.getPackage(_pkg);
  static String get bundle => Env.getBundle(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(const []);

    return MaterialApp(
      home: ConstellationsListDemo(),
    );
  }
}
