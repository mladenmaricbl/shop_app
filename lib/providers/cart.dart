import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get getItems {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.00;

    _items.forEach((key, value) {

      total += value.price * value.quantity;

    });

    return total;
  }

  void addCartItem(String productId, String title, double price, String productImageUrl){
    if(_items.containsKey(productId)){
      _items.update(productId, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          productImgUrl: existingCartItem.productImgUrl,
      ));
    }else{
      _items.putIfAbsent(productId, () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
          productImgUrl: productImageUrl,
      ));
    }
    notifyListeners();
  }

/*  Future<void> addCartItem(String title, double price, String productImageUrl) async {
    final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/cart.json');

    try{
      final response = await http.post(url, body: json.encode({
        'title': title,
        'price': price,
        'imageUrl': productImageUrl,
      })
      );

      print(json.decode(response.body));

      notifyListeners();
    }catch(error){
      print(error);
    }
  }*/

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }

  void undoAddingCartItem(String productId){
    if(!_items.containsKey(productId) ){
      return;
    }
    if(_items[productId].quantity > 1){
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        quantity: existingCartItem.quantity - 1,
        price: existingCartItem.price,
        productImgUrl: existingCartItem.productImgUrl,
      ));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

}