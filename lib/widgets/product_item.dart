import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_item.dart';
import 'package:shop_app/screens/products_details_screen.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            //Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ProductDetailsScreen()));
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.fill,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: product.isFavorite? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: (){
                product.togleIsFavorite(auth.getToken, auth.getUser);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: (){
              cart.addCartItem(product.id, product.title, product.price, product.imageUrl);
              ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added item to the card'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.red,
                    onPressed: (){
                      cart.undoAddingCartItem(product.id);
                    },
                  )
              ));
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
