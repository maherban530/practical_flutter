import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/design_strip_controller.dart';
import '../Model/design_strip_model.dart';

class DesignStripView extends StatelessWidget {
  DesignStripView({super.key});

  final DesignTripController designTripController =
      Get.put(DesignTripController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Test Strip"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: designTripController.designList.length,
        itemBuilder: (context, index) {
          return cardListWidget(index, designTripController.designList[index]);
        },
      ),
    );
  }

  Widget cardListWidget(int ind, DesignTripModel designTripModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 30,
              height: 52,
              decoration: BoxDecoration(
                border: Border(
                  top: ind == 0
                      ? const BorderSide(color: Colors.grey)
                      : BorderSide.none,
                  right: const BorderSide(color: Colors.grey),
                  left: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(designTripModel.title ?? '')),
            SizedBox(
              width: 100,
              child: Obx(
                () => TextFormField(
                  controller: TextEditingController()
                    ..text =
                        designTripController.selectColor[ind].colorName!.value
                    ..selection = TextSelection.collapsed(
                        offset: designTripController
                            .selectColor[ind].colorName!.value.length),
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      designTripController.selectColor[ind] = designTripModel
                          .colorList!
                          .where((e) => e.colorName!.value.contains(val))
                          .first;
                    }
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: '',
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 30,
                        height: 30,
                        color:
                            designTripController.selectColor[ind].color?.value,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 30,
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              ind == designTripController.designList.length - 1
                                  ? const BorderSide(color: Colors.grey)
                                  : BorderSide.none,
                          right: const BorderSide(color: Colors.grey),
                          left: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Row(
                children: [
                  ...List.generate(designTripModel.colorList?.length ?? 0, (i) {
                    var colorData = designTripModel.colorList?[i];

                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => designTripController.selectColor[ind] =
                                designTripModel.colorList![i],
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 30,
                              color: colorData?.color?.value,
                            ),
                          ),
                          Text(colorData?.colorName?.value ?? '')
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
