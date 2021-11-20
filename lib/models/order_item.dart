import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';

class OrderItem{
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.total,
    @required this.products,
    @required this.dateTime,
  });

}