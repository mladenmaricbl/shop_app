import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _resetIsFavorite(bool value){
    isFavorite = value;
    notifyListeners();
  }

  Future<void> togleIsFavorite(String authToken, String user) async {
   var favoriteOldValue = isFavorite;
   isFavorite = !isFavorite;
   notifyListeners();
   final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$user/$id.json?auth=$authToken');
   try{
     final response = await http.put(url, body: json.encode(
       isFavorite,
     )
     );
     if(response.statusCode >= 400) {
       _resetIsFavorite(favoriteOldValue);
     }
   }catch(error){
     _resetIsFavorite(favoriteOldValue);
   }
  }
}