import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/dashboard_controller.dart';
import 'tabbar_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int initPosition = 0;

  DashboardController dashboardController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => CustomTabView(
            initPosition: initPosition,
            itemCount: dashboardController
                    .dashboardData.value.result?.category?.length ??
                0,
            tabBuilder: (context, index) => Tab(
                text: dashboardController
                        .dashboardData.value.result?.category?[index].name ??
                    ''),
            onPositionChange: (ind) {
              initPosition = ind;
              dashboardController.selectCategory.value = dashboardController
                  .dashboardData.value.result!.category![ind];
              dashboardController.subcategoryApi();
            },
            onScroll: (position) {
              print('$position');
            },
            pageBuilder: (context, index) => Obx(
              () => dashboardController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : subCategoryWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget subCategoryWidget() {
    return SingleChildScrollView(
      controller: dashboardController.controller,
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dashboardController.subCategoryData.value.result
                      ?.category?[0].subCategories?.length ??
                  0,
              itemBuilder: (context, ind) {
                var subCategoryData = dashboardController.subCategoryData.value
                    .result?.category?[0].subCategories?[ind];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subCategoryData?.name ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // controller: dashboardController.controllerHorizontal,
                        child: Row(
                          children: [
                            ...List.generate(
                              subCategoryData?.product?.length ?? 0,
                              (i) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        subCategoryData
                                                ?.product?[i].imageName ??
                                            '',
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.fill,

                                        // loadingBuilder: (context, child,
                                        //         loadingProgress) =>
                                        //     const SizedBox(
                                        //         height: 150,
                                        //         width: 150,
                                        //         child: Center(
                                        //             child:
                                        //                 CircularProgressIndicator())),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        subCategoryData?.product?[i].name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(
            () => Visibility(
              visible: dashboardController.isLoadingMore.value == true,
              child: const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: dashboardController.hasNextPage.value == false,
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: const Center(
                  child: Text('You have fetched all of the subCategory',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
