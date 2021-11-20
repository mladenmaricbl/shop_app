import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/orders_item_widget.dart';
import 'package:shop_app/widgets/main_drawer.dart';

class OrdersScreen extends StatefulWidget {

  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).fetchOrders().catchError((_){
        setState(() {
          _isLoading = false;
        });
        //todo show error message
      }).then((_) {
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
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Orders'),
      ),
      drawer: MainDrawer(),
      body: _isLoading ?
      Center(
        child: CircularProgressIndicator(),
      )
          :
      ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context, i) => OrdersItemWidget(ordersData.orders[i]),
      )
    );
  }
}
