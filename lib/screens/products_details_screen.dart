import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'package:shop_app/widgets/main_drawer.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  // kad stavimo lisen: false onda se ovaj widget nece bildati sa svakom promjenom liset produkata
  // jer u ovom slucaju nam i ne treba da se UI mijenja kad se lista promijeni.

  Widget buildSectionTitle(BuildContext ctx, String title){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildSectionSubtitle(BuildContext ctx, String description){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black38,
        ),
      ),
    );
  }

  Widget buildContainer(Widget child){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.grey
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productData = Provider.of<ProductsProvider>(context, listen: false);
    final product = productData.getProductById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle(context, product.title),
            buildSectionSubtitle(context, product.description)
          ],
        ),
      ),
    );
  }
}