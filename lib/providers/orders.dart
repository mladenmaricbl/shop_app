import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String _authToken;

  Orders(this._authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$_authToken');
    try {
      final response = await http.get(url);

      if(response == null)
        return;

      final extractedOrdersData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders= [];
      extractedOrdersData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            total: orderData['total'],
            products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
              productImgUrl: item['productImgUrl']
            )).toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }catch(error){
      print(error);
      throw (error);
    }
  }

/*  void addOrder(List<CartItem> cartProducts, double total){
    _orders.insert(0, OrderItem(
      id: DateTime.now().toString(),
      total: total,
      dateTime: DateTime.now(),
      products: cartProducts,
    ));
    notifyListeners();
  }*/

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$_authToken');
    final timeStamp = DateTime.now();
    try{
      final response = await http.post(url, body:json.encode({
        'total': total,
        'products': cartProducts.map((cartProduct) => {
          'id': cartProduct.id,
          'title': cartProduct.title,
          'quantity': cartProduct.quantity,
          'price': cartProduct.price,
          'productImgUrl': cartProduct.productImgUrl
        }
        ).toList(),
        'dateTime': timeStamp.toIso8601String()
      }));

      final newOrder = OrderItem(
          id: json.decode(response.body)['name'],
          total: total,
          products: cartProducts,
          dateTime: timeStamp
      );

      _orders.insert(0, newOrder);
      notifyListeners();

    }catch(error){
      print('error u order provideru');
      throw(error);
    }
  }
}