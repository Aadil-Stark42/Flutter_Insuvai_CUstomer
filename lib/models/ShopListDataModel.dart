import 'ShopDetailsDataModel.dart';

class ShopListDataModel {
  bool? status;
  String? message;
  String? shopCategoryId;
  List<Shops>? shops;

  List<Products>? products;

  ShopListDataModel(
      {this.status,
      this.message,
      this.shopCategoryId,
      this.shops,
      this.products});

  ShopListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shopCategoryId = json['shop_category_id'];
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(Shops.fromJson(v));
      });
    }

    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['shop_category_id'] = shopCategoryId;
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }

    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  int? shopId;
  String? shopName;
  String? shopImage;
  String? shopArea;
  String? shopAddress;
  String? price;
  String? distance;
  String? time;
  int? rating;
  int? ratingCount;
  bool? isOpened;

  Shops(
      {this.shopId,
      this.shopName,
      this.shopImage,
      this.shopArea,
      this.shopAddress,
      this.price,
      this.distance,
      this.time,
      this.rating,
      this.ratingCount,
      this.isOpened});

  Shops.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopImage = json['shop_image'];
    shopArea = json['shop_area'];
    shopAddress = json['shop_address'];
    price = json['price'];
    distance = json['distance'];
    time = json['time'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    isOpened = json['is_opened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop_id'] = shopId;
    data['shop_name'] = shopName;
    data['shop_image'] = shopImage;
    data['shop_area'] = shopArea;
    data['shop_address'] = shopAddress;
    data['price'] = price;
    data['distance'] = distance;
    data['time'] = time;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    data['is_opened'] = isOpened;
    return data;
  }
}

class Products {
  int? productId;
  String? productName;
  String? productImage;
  String? description;
  int? variety;
  List<Variants>? variants;

  Products(
      {this.productId,
      this.productName,
      this.productImage,
      this.description,
      this.variety,
      this.variants});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    description = json['description'];
    variety = json['variety'];

    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['description'] = description;
    data['variety'] = variety;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
