import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/dashboard_model.dart';
import '../service.dart';

class DashboardController extends GetxController {
  Rx<DashboardModel> dashboardData = DashboardModel().obs;
  RxBool isLoading = false.obs;

  Rx<DashboardModel> subCategoryData = DashboardModel().obs;
  Rx<Category> selectCategory = Category().obs;

  // Rx<ProductModel> productData = ProductModel().obs;
  Rx<SubCategories> selectSubCategory = SubCategories().obs;
  // RxList<ProductModel> data = RxList<ProductModel>.filled(0, false, growable: true).obs;

  RxInt page = 1.obs;
  RxBool hasNextPage = true.obs;
  RxBool isLoadingMore = false.obs;

  RxInt pageProd = 1.obs;
  RxBool hasNextPageProd = true.obs;
  RxBool isLoadingMoreProd = false.obs;

  late ScrollController controller = ScrollController();
  late ScrollController controllerHorizontal = ScrollController();

  @override
  void onInit() {
    dashboardApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(_loadMoresubcategoryApi);
      controllerHorizontal.addListener(_loadMoreproductApi);
    });

    // controller.addListener(() {
    //   if (controller.offset != controllerHorizontal.offset) {
    //     // controllerHorizontal.jumpTo(controller.offset);
    //     _loadMoresubcategoryApi();
    //   }
    // });
    // controllerHorizontal.addListener(() {
    //   if (controller.offset != controllerHorizontal.offset) {
    //     // controller.jumpTo(controllerHorizontal.offset);
    //     _loadMoreproductApi();
    //   }
    // });

    super.onInit();
  }

  void dashboardApi() async {
    var categoryData = await ApiServices().dashboardService(page: page.value);

    if (categoryData.status == 200) {
      isLoading.value = false;
      dashboardData.value = categoryData;
      if (categoryData.result!.category!.isNotEmpty) {
        selectCategory.value = categoryData.result!.category![0];
      }
      subcategoryApi();
    }
  }

  void subcategoryApi() async {
    page.value = 1;
    hasNextPage.value = true;
    isLoadingMore.value = false;

    isLoading.value = true;

    var subCategory = await ApiServices().subcategoryService(
        categoryId: selectCategory.value.id!, page: page.value);

    if (subCategory.status == 200) {
      isLoading.value = false;
      subCategoryData.value = subCategory;
      if (subCategory.result!.category![0].subCategories!.isNotEmpty) {
        selectSubCategory.value =
            subCategory.result!.category![0].subCategories![0];
      }

      for (int i = 0;
          i < subCategory.result!.category![0].subCategories!.length;
          i++) {
        productApi(
            subCategoryId:
                subCategory.result!.category![0].subCategories![i].id!,
            index: i);
      }
    }
  }

  void _loadMoresubcategoryApi() async {
    if (hasNextPage.value == true &&
        isLoading.value == false &&
        isLoadingMore.value == false &&
        controller.position.extentAfter < 300) {
      isLoadingMore.value = true;

      page.value += 1;
      try {
        var subCategoryDataLoadMore = await ApiServices().subcategoryService(
            categoryId: selectCategory.value.id!, page: page.value);

        if (subCategoryDataLoadMore
                .result?.category?[0].subCategories?.isNotEmpty ??
            false) {
          subCategoryData.value.result?.category?[0].subCategories?.addAll(
              subCategoryDataLoadMore.result!.category![0].subCategories!);

          for (int i = 0;
              i <
                  subCategoryData
                      .value.result!.category![0].subCategories!.length;
              i++) {
            productApi(
                subCategoryId: subCategoryData
                    .value.result!.category![0].subCategories![i].id!,
                index: i);
          }
        } else {
          hasNextPage.value = false;
        }
      } catch (err) {}

      isLoadingMore.value = false;
    }
  }

  void productApi({required int subCategoryId, required int index}) async {
    pageProd.value = 1;
    hasNextPageProd.value = true;
    isLoadingMoreProd.value = false;

    // isLoading.value = true;

    var productDetails = await ApiServices()
        .productService(subCategoryId: subCategoryId, page: pageProd.value);

    if (productDetails.status == 200) {
      isLoading.value = false;
      // productData.value = productDetails;
      subCategoryData.value.result?.category![0].subCategories![index].product =
          productDetails.result!;
    }
  }

  void _loadMoreproductApi() async {
    if (hasNextPageProd.value == true &&
        isLoading.value == false &&
        isLoadingMoreProd.value == false &&
        controllerHorizontal.position.maxScrollExtent ==
            controllerHorizontal.offset) {
      isLoadingMoreProd.value = true;

      pageProd.value += 1;

      var index = (controllerHorizontal.offset /
                  subCategoryData
                      .value.result!.category![0].subCategories!.length)
              .round() +
          1;

      try {
        var productDataLoadMore = await ApiServices().productService(
            subCategoryId: selectSubCategory.value.id!, page: pageProd.value);

        if (productDataLoadMore.result?.isNotEmpty ?? false) {
          // productData.value.result?.addAll(productDataLoadMore.result!);
          subCategoryData.value.result?.category![0].subCategories![index]
              .product = productDataLoadMore.result!;
        } else {
          hasNextPageProd.value = false;
        }
      } catch (err) {}

      isLoadingMoreProd.value = false;
    }
  }

  @override
  void onClose() {
    controller.dispose();
    controllerHorizontal.dispose();
    super.onClose();
  }
}
