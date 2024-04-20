import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/design_strip_model.dart';

class DesignTripController extends GetxController {
  RxList<DesignTripModel> designList = <DesignTripModel>[
    DesignTripModel(title: "Total Hardness", colorList: [
      ColorList(color: Colors.red.obs, colorName: '0'.obs),
      ColorList(color: Colors.yellow.obs, colorName: '110'.obs),
      ColorList(color: Colors.green.obs, colorName: '250'.obs),
      ColorList(color: Colors.teal.obs, colorName: '350'.obs),
      ColorList(color: Colors.brown.obs, colorName: '400'.obs),
    ]),
    DesignTripModel(title: "Total Cones", colorList: [
      ColorList(color: Colors.green.obs, colorName: '0'.obs),
      ColorList(color: Colors.red.obs, colorName: '1'.obs),
      ColorList(color: Colors.yellow.obs, colorName: '2'.obs),
      ColorList(color: Colors.brown.obs, colorName: '3'.obs),
      ColorList(color: Colors.teal.obs, colorName: '4'.obs),
    ]),
    DesignTripModel(title: "Total yery", colorList: [
      ColorList(color: Colors.brown.obs, colorName: '2.0'.obs),
      ColorList(color: Colors.teal.obs, colorName: '3.5'.obs),
      ColorList(color: Colors.red.obs, colorName: '4.4'.obs),
      ColorList(color: Colors.yellow.obs, colorName: '6.1'.obs),
      ColorList(color: Colors.green.obs, colorName: '7.0'.obs),
    ]),
  ].obs;

  RxList<ColorList> selectColor =
      List<ColorList>.filled(0, ColorList(), growable: true).obs;

  @override
  void onInit() {
    selectColor.value =
        List<ColorList>.filled(designList.length, ColorList(), growable: true);
    for (int i = 0; i < designList.length; i++) {
      selectColor[i] = designList[i].colorList![0];
    }
    super.onInit();
  }
}
