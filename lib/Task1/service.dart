import 'dart:convert';

import 'package:dio/dio.dart';

import 'Model/dashboard_model.dart';
import 'Model/product_model.dart';
import 'api_url.dart';

class ApiServices {
  final Dio _dio = Dio();

  Future<DashboardModel> dashboardService({required int page}) async {
    var formData = json.encode({
      "Category": 0,
      "DeviceManufacture": "Google",
      "DeviceModel": "Android SDK built for x86",
      "DeviceToken": "",
      "PageIndex": page
    });

    try {
      Response response = await _dio.request(ApiUrl.dashboardUrl,
          options: Options(
            method: 'POST',
          ),
          data: formData);

      if (response.data['Status'] == 200) {
        return DashboardModel.fromJson(response.data);
      } else {
        return DashboardModel();
      }
    } on DioException catch (e) {
      if (e.response != null) {
      } else {}
      return DashboardModel();
    }
  }

  Future<DashboardModel> subcategoryService(
      {required int page, required int categoryId}) async {
    var formData = json.encode({"CategoryId": categoryId, "PageIndex": page});

    try {
      Response response = await _dio.request(ApiUrl.dashboardUrl,
          options: Options(
            method: 'POST',
          ),
          data: formData);

      if (response.data['Status'] == 200) {
        return DashboardModel.fromJson(response.data);
      } else {
        return DashboardModel();
      }
    } on DioException catch (e) {
      if (e.response != null) {
      } else {}
      return DashboardModel();
    }
  }

  Future<ProductModel> productService(
      {required int page, required int subCategoryId}) async {
    var formData =
        json.encode({"SubCategoryId": subCategoryId, "PageIndex": page});

    try {
      Response response = await _dio.request(ApiUrl.productUrl,
          options: Options(
            method: 'POST',
          ),
          data: formData);

      if (response.data['Status'] == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        return ProductModel();
      }
    } on DioException catch (e) {
      if (e.response != null) {
      } else {}
      return ProductModel();
    }
  }
}
