import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String status;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.status,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sản phẩm',
      category: json['category']?.toString() ?? '',
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      status: json['status']?.toString() ?? 'con_hang',
      description: json['description']?.toString() ?? '',
    );
  }

  String get formattedPrice {
    final intPrice = price.toInt();
    final str = intPrice.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return '$formatted đ';
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'con_hang':
        return 'Còn hàng';
      case 'het_hang':
        return 'Hết hàng';
      case 'ngung_ban':
        return 'Ngừng bán';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'con_hang':
        return Colors.green.shade700;
      case 'het_hang':
        return Colors.orange.shade800;
      case 'ngung_ban':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}