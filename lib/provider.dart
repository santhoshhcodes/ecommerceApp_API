import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProduct extends ChangeNotifier{

  List<Map<String,dynamic>> cartProduct = [];
  List<Map<String,dynamic>> get cartList => cartProduct;

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("cart");
    if (data != null) {
      cartProduct = List<Map<String, dynamic>>.from(json.decode(data));
      notifyListeners();
    }
  }
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cart", json.encode(cartProduct));
  }
  bool addtocart(Map<String,dynamic>oneProduct){
    for (var x in cartProduct){
      if(x["id"]== oneProduct["id"]){
        x["quantity"] = (x["quantity"] ?? 1) + (oneProduct["quantity"] ?? 1);
        notifyListeners();
        return true;
      }
    }
    cartProduct.add(oneProduct);
    notifyListeners();
    return false;
  }
  removecart(Map<String,dynamic> value)
  {
    cartProduct.remove(value);
    notifyListeners();
  }
  increase(){

  }
}
class WishlistProvider extends ChangeNotifier{
  List<Map<String,dynamic>> wishlist = [];
  List<Map<String,dynamic>> get wish => wishlist;
  Future<void> load() async{
    final prefer = await SharedPreferences.getInstance();
    String? data =prefer.getString("wish");
    if(data != null){
      wishlist = List<Map<String,dynamic>>.from(json.decode(data));
      notifyListeners();
    }

  }
  Future<void> save() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wish", json.encode(wishlist));
  }


  bool addtolist(Map<String,dynamic>oneProduct){
    for (var x in wishlist){
      if(x["id"]== oneProduct["id"]){
        x["quantity"] = (x["quantity"] ?? 1) + (oneProduct["quantity"] ?? 1);
        notifyListeners();
        return true;
      }
    }
    wishlist.add(oneProduct);
    notifyListeners();
    return false;
  }
  void removelistById(int id) {
    wishlist.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }


  increaseWishlist(){

  }

}