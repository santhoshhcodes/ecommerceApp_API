import 'package:ecom_api/allPro.dart';
import 'package:ecom_api/cart.dart';
import 'package:ecom_api/categories.dart';
import 'package:ecom_api/themeProvider.dart';
import 'package:ecom_api/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class buttomnav extends StatefulWidget {
  final String username;
  const buttomnav({super.key, required this.username});

  @override
  State<buttomnav> createState() => _buttomnavState();
}

class _buttomnavState extends State<buttomnav> {

  int _index =0;



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screen = [
      Allpro(username: widget.username),
      Cart(),
      Wishlist(),
      Categories(),
    ];
    void tap(index){
      setState(() {
        _index = index;
      });
    }
    return Scaffold(
      body: screen[_index],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: themeProvider.isDarkMode ? Colors.white10 : Colors.black38,
        selectedItemColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart), label: "cart"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.square_favorites_alt_fill), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),

        ],
        currentIndex: _index,
        onTap: tap,
      ),
    );
  }
}
