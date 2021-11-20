import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/manage_products_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler){
    return ListTile(
      leading: Icon(
        icon,
        size: 26,),
      title: Text(
          title,
          style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
              fontSize: 24
          )
      ),
      onTap:tapHandler,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
              'Shop',
              Icons.shop,
                  (){
                Navigator.of(context).pushReplacementNamed('/');
              }
          ),
          Divider(),
          buildListTile(
              'Order',
              Icons.credit_card,
                  (){
                    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              }
          ),
          Divider(),
          buildListTile(
              'Manage Products',
              Icons.settings,
                  (){
                    Navigator.of(context).pushReplacementNamed(ManageProductsScreen.routeName);
              }
          ),
          Divider(),
          buildListTile(
              'Logout',
              Icons.logout,
                  (){
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logOut();
              }
          )
        ],
      ),
    );
  }
}
