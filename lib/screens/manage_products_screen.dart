import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/manage_product_item_widget.dart';

class ManageProductsScreen extends StatelessWidget {

  static const routeName = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage products'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: MainDrawer(),
      // Ovo se moglo uraditi isto kao u products_overview_screen sa didChangeDependencies()
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator())
            :
        RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<ProductsProvider>(
            builder:(ctx, productsData, _) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (context, index) => ManageProductItemWidget(
                      title: productsData.items[index].title,
                      imageUrl: productsData.items[index].imageUrl,
                      productId: productsData.items[index].id
                  ),
                ),
            ),
          ),
        ),
      )
    );
  }
}
