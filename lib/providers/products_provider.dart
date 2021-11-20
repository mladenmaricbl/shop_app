import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/providers/product_item.dart';

class ProductsProvider with ChangeNotifier {

  final String _authToken;
  final String _userId;

  ProductsProvider(this._authToken, this._userId, this._items);

  List<Product> _items = [
   /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  //var _showFavoritesOnly = false;

  List<Product> get items {
    /*if(_showFavoritesOnly){
      return _items.where((item) => item.isFavorite).toList();
    }*/
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product getProductById(String id){
    return _items.firstWhere((item) => item.id == id);
  }

/*
  void showFavoritesOnly(){
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll(){
    _showFavoritesOnly = false;
    notifyListeners();
  }*/

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    var url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken&$filterString');
    try{
      final response = await http.get(url);

      if(response == null)
        return;

      url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$_userId.json?auth=$_authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>; // mozemo koristiti i Map<String, Object>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: favoriteData == null ? false : favoriteData[productId] ?? false, // ?? provjerava da li je vrijednost sa lijeve strane null ako nije uzece tu vrijednos, ako jeste uzece vrijednost sa desne strane!
          ));
      });
      _items = loadedProducts;
      notifyListeners();

    }catch(error){
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken');
    try{
      final response = await http.post(url, body:json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId': _userId
      })
      );

      print(json.decode(response.body));
      final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl
      );
      //_items.add(newProduct);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch(error){
      print(error);
      throw error;
    }

  }

  //pr. koristenja Optimistic update!
  void removeProduct(String productId){
    final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$_authToken');
    final itemIndex = _items.indexWhere((element) => element.id == productId);
    var product = _items[itemIndex];

    _items.removeWhere((element) => element.id == productId);
    http.delete(url).then((_){
      product = null;
    }).catchError((_){
      _items.insert(itemIndex, product);
    });
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if(prodIndex >= 0){
      final url = Uri.parse('https://shop-app-e07ae-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$_authToken');
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

}