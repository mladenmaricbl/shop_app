import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/shop';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}


class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  /*@override
  void initState(){
    // U init state nemamo dostupan 'context' jer se jos kreira
    // tako da ako koristimo initState za fetchanje podataka sa servera
    // mozemo koristiti hak.
    Future.delayed(Duration.zero).then((_) => {
      Provider.of<ProductsProvider>(context).fetchProducts();
    });
    super.initState();
  }*/

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
   // final productsContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Shop'),
      actions: [
        PopupMenuButton(
          onSelected: (int selectedValue){
            setState(() {
              if(selectedValue == 0){
                _showOnlyFavorites = true;
              }else{
                _showOnlyFavorites = false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) =>[
            PopupMenuItem(child: Text('Only Favorites'), value: 0,),
            PopupMenuItem(child: Text('Show All'), value: 1,)
        ]),
        Consumer<Cart> (builder: (_, cart, ch) => Badge(
           child: ch,
           value: cart.itemCount.toString(),
          ),
        child: IconButton(
          onPressed: (){
            Navigator.of(context).pushNamed(CartScreen.routeName);

          },
          icon: Icon(Icons.shopping_cart)),
        ),
      ],
      ),
      drawer: MainDrawer(),
      body:_isLoading ?
      Center(
        child: CircularProgressIndicator(),
      )
          :
      ProductsGrid(_showOnlyFavorites),
    );
  }
}
