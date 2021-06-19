import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_delivery/fragments/contact_us_fragment.dart';
import 'package:gas_delivery/fragments/my_orders.dart';
import 'package:gas_delivery/fragments/my_payments.dart';
import 'package:gas_delivery/fragments/profile_fragment.dart';
import 'package:gas_delivery/main.dart';
import 'package:gas_delivery/ui/signin.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';

import '../fragments/dashboard.dart';
import 'checkout_screen.dart';

class DrawerItem {
  String title;
  IconData icon;
  MENU_ITEM menu_item;

  DrawerItem(this.title, this.icon, this.menu_item);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home, MENU_ITEM.HOME),
    new DrawerItem("My Orders", Icons.list, MENU_ITEM.MY_ORDERS),
    new DrawerItem("My Payments", Icons.money, MENU_ITEM.MY_PAYMENTS),
    new DrawerItem("Profile", Icons.person, MENU_ITEM.MY_PROFILE),
    new DrawerItem(
        "Follow Us", Icons.contact_mail_outlined, MENU_ITEM.CONTACT_US),
    new DrawerItem("Log Out", Icons.logout, MENU_ITEM.LOGOUT)
  ];

  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(MENU_ITEM menu_item) {
    switch (menu_item) {
      case MENU_ITEM.HOME:
        return new DashboardPage(
          flutterCart: cart,
          refreshFunction: refresh,
        );
      case MENU_ITEM.MY_ORDERS:
        return new MyOrdersPage();
      case MENU_ITEM.MY_PROFILE:
        return new ProfileFragment();
      case MENU_ITEM.MY_PAYMENTS:
        return new PaymentsFragment();
      case MENU_ITEM.CONTACT_US:
        return new ContactFragment();
      case MENU_ITEM.LOGOUT:
        logout();
        Future.delayed(Duration.zero, () {
          navigateToPageRemoveHistory(context, SignInPage());
        });
        break;
    }
  }

  Future<void> logout() async {
    await clearAllPreferences();
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  String? username = '', email = '';

  Future<void> fetchUserName() async {
    String? u = await getName();
    String? e = await getEmail();
    setState(() {
      username = u;
      email = e;
    });
  }

  var cartCount;

  void refresh(int newCartCount) {
    setState(() {
      cartCount = newCartCount;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  late FlutterCart cart;

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    cart = new FlutterCart();

    cartCount = cart.getCartItemCount();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: [
          GestureDetector(
            onTap: () {
              if (cartCount == 0) {
                Fluttertoast.showToast(
                    msg: "You must first add items to cart",
                    toastLength: Toast.LENGTH_LONG);
              } else {
                navigateToPage(
                    context,
                    CheckOutPage(
                      flutterCart: cart,
                    ));
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 10),
              child: Badge(
                badgeContent: Text("$cartCount"),
                child: Icon(Icons.shopping_cart),
              ),
            ),
          )
        ],
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: new Drawer(
          child: new Column(
            children: [
              new UserAccountsDrawerHeader(
                accountName: new Text("$username"),
                accountEmail: Text("$email"),
                currentAccountPicture: Image.asset('assets/logo.jpeg'),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(
          widget.drawerItems[_selectedDrawerIndex].menu_item),
    );
  }
}
