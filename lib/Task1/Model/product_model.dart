import 'dashboard_model.dart';

class ProductModel {
  int? status;
  String? message;
  List<Product>? result;

  ProductModel({this.status, this.message, this.result});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Result'] != null) {
      result = <Product>[];
      json['Result'].forEach((v) {
        result!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.result != null) {
      data['Result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
