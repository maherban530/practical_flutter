import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesignTripModel {
  String? title;
  List<ColorList>? colorList;

  DesignTripModel({this.title, this.colorList});

  DesignTripModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['prod_options'] != null) {
      colorList = <ColorList>[];
      json['prod_options'].forEach((v) {
        colorList!.add(ColorList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (colorList != null) {
      data['prod_options'] = colorList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ColorList {
  Rx<Color>? color = Colors.transparent.obs;
  RxString? colorName = ''.obs;

  ColorList({this.color, this.colorName});

  ColorList.fromJson(Map<String, dynamic> json) {
    color?.value = json['color'];
    colorName?.value = json['colorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color?.value;
    data['colorName'] = colorName?.value;
    return data;
  }
}
