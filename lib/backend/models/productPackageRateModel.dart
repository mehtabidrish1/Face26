// To parse this JSON data, do
//
//     final productPackageList = productPackageListFromJson(jsonString);

import 'dart:convert';

ProductPackageList productPackageListFromJson(String str) => ProductPackageList.fromJson(json.decode(str));

String productPackageListToJson(ProductPackageList data) => json.encode(data.toJson());

class ProductPackageList {
    ProductPackageList({
        required this.products,
    });

    List<Product> products;
    

    factory ProductPackageList.fromJson(Map<String, dynamic> json) => ProductPackageList(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    Product({
        required this.description,
       required this.highlight,
      required  this.id,
      required  this.price,
      required  this.quantity,
       required this.title,
    });

    String description;
    bool highlight;
    String id;
    int price;
    int quantity;
    String title;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        description: json["description"],
        highlight: json["highlight"],
        id: json["id"],
        price: json["price"],
        quantity: json["quantity"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "highlight": highlight,
        "id": id,
        "price": price,
        "quantity": quantity,
        "title": title,
    };
}
