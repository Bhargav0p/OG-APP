import 'package:flutter/material.dart';

class ConstellationData {
  final String title;
  final String subTitle;
  final String image;

  final UniqueKey key = UniqueKey();

  ConstellationData(this.title, this.subTitle, this.image);
}

class DemoData {
  static final List<ConstellationData> _constellations = [
    ConstellationData("Prabhas", "App", "PrabhasKumarAlamuri.png"),
    ConstellationData("Shashvat", "App", "ShashvatSingh.png"),
    ConstellationData("Shivang", "UI/UX", "ShivangRai.png"),
    ConstellationData("Achinthya", "App", "AchinthyaHebbar.png"),
    ConstellationData("Lovenya", "App", "LovenyaJain.png"),
    ConstellationData("Sejal", "UI/UX", "SejalAgarwal.png"),
    ConstellationData("Swaha", "UI/UX", "SwahaPati.png"),
    ConstellationData("Satwik", "UI/UX", "SatwikRath.png"),
    ConstellationData("Harsh", "Backend", "HarshSingh.png"),
    ConstellationData("Harshith", "Backend", "HarshithVasireddy.png"),
    ConstellationData("Utkarsh", "Backend", "UtkarshSharma.png"),
    ConstellationData("Maanas", "Backend", "MaanasSingh.png"),
    ConstellationData("Prakhar", "Backend", "PrakharGurunani.png"),
  ];

  List<ConstellationData> getConstellations() => _constellations;
}
