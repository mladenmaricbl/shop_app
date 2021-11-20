import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shop_app/models/order_item.dart';


class OrdersItemWidget extends StatefulWidget {
  final OrderItem order;

  OrdersItemWidget(this.order);

  @override
  _OrdersItemWidgetState createState() => _OrdersItemWidgetState();
}

class _OrdersItemWidgetState extends State<OrdersItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.total}'),
            subtitle: Text(DateFormat('dd-MM-yyyy').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) Container(
            padding: const EdgeInsets.all(10.0),
            height: 180,
            child: ListView.builder(
              itemCount: widget.order.products.length,
              itemBuilder: (context, i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.order.products[i].title),
                  Text('${widget.order.products[i].quantity} x ${widget.order.products[i].price}\$'),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
