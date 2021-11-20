import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';


class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your cart'),
      ),
      //drawer: MainDrawer(),
      body: Column(
        children:[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Total: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${ cartData.totalAmount }',
                      style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.headline1.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  OrderButton(cartData: cartData)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.itemCount,
              itemBuilder: (context, i) => CartItemWidget(
                cartData.getItems.values.toList()[i].id,
                cartData.getItems.values.toList()[i].productImgUrl,
                cartData.getItems.values.toList()[i].title,
                cartData.getItems.values.toList()[i].price.toString(),
                cartData.getItems.values.toList()[i].quantity.toString(),
                cartData.getItems.keys.toList()[i],
              ),
              ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {

  final Cart cartData;

  const OrderButton({
    @required this.cartData,
  });

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    Future<void> _addOrder() async {

      setState(() {
        _isLoading = true;
      });
      try{
        await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cartData.getItems.values.toList(),
            widget.cartData.totalAmount
        );
        widget.cartData.clear();

      }catch(error){
        print('error');
        //todo something with error
      }finally{
        setState(() {
          _isLoading = false;
        });
      }
    }

    return FlatButton(
        onPressed: (widget.cartData.totalAmount <= 0 || _isLoading) ? null : _addOrder,
        child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}