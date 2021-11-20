import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {

  final String id;
  final String productImage;
  final String productTitle;
  final String productPrice;
  final String productQuantity;
  final String productId;

  CartItemWidget(
    this.id,
    this.productImage,
    this.productTitle,
    this.productPrice,
    this.productQuantity,
    this.productId,
    );


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      confirmDismiss: (direction){
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Do you want to delete this item?'),
              actions: [
                FlatButton(
                    onPressed: (){
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No'),
                ),
              ],
            ),
        );
      },
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: FittedBox(
                  child: Image.network(
                    productImage,
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(productTitle),
                subtitle: Text('\$$productPrice'),
                trailing: Text(productQuantity),
              ),
          )
      ),
    );
  }
}

