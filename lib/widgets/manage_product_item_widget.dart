import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class ManageProductItemWidget extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  ManageProductItemWidget({@required this.title, @required this.imageUrl, @required this.productId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: productId);
                },
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
            ),
            IconButton(
                onPressed: (){
                  Provider.of<ProductsProvider>(context, listen: false).removeProduct(productId);
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
            ),
          ]),
      ),
    );
  }
}
