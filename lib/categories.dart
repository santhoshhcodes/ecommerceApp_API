import 'dart:convert';

import 'package:ecom_api/provider.dart';
import 'package:ecom_api/single_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'buttom.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

List image = [
  "assets/cat/beauty.png",
  "assets/cat/fragrances.webp",
  "assets/cat/furniture.webp",
  "assets/cat/groceries.png",
  "assets/cat/home-decoration.jpeg",
  "assets/cat/kitchen-accessories.webp",
  "assets/cat/laptops.jpg",
  "assets/cat/mens-shirts.jpg",
  "assets/cat/mens-shoes.webp",
  "assets/cat/mens-watches.jpeg",
  "assets/cat/mobile-accessories.jpg",
  "assets/cat/motorcycle.jpeg",
  "assets/cat/skin-care.jpg",
  "assets/cat/smartphones.jpeg",
  "assets/cat/sports-accessories.webp",
  "assets/cat/sunglasses.jpeg",
  "assets/cat/tops.webp",
  "assets/cat/vehicle.jpeg",
  "assets/cat/tablets.webp",
  "assets/cat/womens-bags.jpeg",
  "assets/cat/womens-dresses.png",
  "assets/cat/womens-jewellery.jpg",
  "assets/cat/womens-shoes.jpg",
  "assets/cat/womens-watches.jpeg",
];

List<dynamic> catList = [];
int selectedIndex = 0;
List<dynamic> selectedProduct = [];

class _CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> Draw = GlobalKey<ScaffoldState>();

  int count = 1;

  //bool heart = true;
  Set<int> likedProducts = {};
  bool isSearching = false;

  Future<void> getData() async {
    try {
      var apiRes = await http.get(
        Uri.parse('https://dummyjson.com/products/category-list'),
      );
      if (apiRes.statusCode == 200 || apiRes.statusCode == 201) {
        setState(() {
          catList = jsonDecode(apiRes.body);
        });
      }
      if (catList.isNotEmpty) {
        getProduct(catList[0]);
      } else {
        throw Exception("Error: Failed to load data");
      }
    } catch (error) {
      throw Exception("Exception: $error");
    }
  }

  Future<void> getProduct(String category) async {
    try {
      var apiResponce = await http.get(
        Uri.parse('https://dummyjson.com/products/category/$category'),
      );
      if (apiResponce.statusCode == 200 || apiResponce.statusCode == 201) {
        var data = jsonDecode(apiResponce.body);
        setState(() {
          selectedProduct = data['products'];
        });
      } else {
        throw Exception("error");
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  late Future<void> futureData;
  late Future<void> futureProducts;

  @override
  void initState() {
    super.initState();
    futureData = getData();
    futureProducts = getData();
  }

  void refreshProducts() {
    setState(() {
      futureData = getData();
      futureProducts = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var cartObject = Provider.of<CartProduct>(context);
    final likedObject = Provider.of<WishlistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ Colors.black87, Colors.white30
              ],)
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.to(buttomnav(username: 'username',));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            //color: Colors.white
          ),
        ),
        title: Text(
          "Categories",
          style: TextStyle(
            //color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: catList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Container(
                  width: 100,
                  //color: Colors.grey[300],
                  child: ListView.builder(
                    itemCount: catList.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          getProduct(catList[index]);
                        },
                        child: Container(
                         // color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    //color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Image.asset(
                                    image[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${catList[index]}",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          catList[selectedIndex].toString().toUpperCase(),
                          // show selected category
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: catList.isEmpty
                            ? CircularProgressIndicator()
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.70,
                                    ),
                                itemCount: selectedProduct.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var product = selectedProduct[index];
                                  bool isInWishlist = likedObject.wish.any(
                                    (item) => item['id'] == product['id'],
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) =>
                                              SinglePro(id: product['id']),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 4,
                                      //color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Product Image + Heart Button
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    product['images'][0],
                                                    height: 100,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Icon(
                                                          Icons.broken_image,
                                                          size: 50,
                                                        ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 1,
                                                  left: 1,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      if (isInWishlist) {
                                                        likedObject
                                                            .removelistById(
                                                              product['id'],
                                                            );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Product removed from Wishlist!",
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        likedObject.addtolist({
                                                          'id': product['id'],
                                                          'title':
                                                              product['title'],
                                                          'image':
                                                              product['images'][0],
                                                          'price':
                                                              product['price'],
                                                          'discountPercentage':
                                                              product['discountPercentage'],
                                                          'quantity': count,
                                                          'rating':
                                                              product['rating'],
                                                        });
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Product added to Wishlist!",
                                                            ),
                                                            duration: Duration(milliseconds: 500),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      isInWishlist
                                                          ? CupertinoIcons
                                                                .heart_fill
                                                          : CupertinoIcons
                                                                .heart,
                                                      color: Colors.red,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 5),

                                            // Product Title
                                            Text(
                                              product['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            SizedBox(height: 5),

                                            // Price Section
                                            Row(
                                              children: [
                                                Text(
                                                  "Rs. ${(product['price'] + (product['price'] * (product['discountPercentage'] / 100))).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    color: Colors.red[400],
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    //color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      4.0,
                                                    ),
                                                    child: Text(
                                                      "${-product['discountPercentage'].toInt()} off",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Rs. ${product['price'].toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            SizedBox(height: 5),

                                            // Add to Cart Button
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                              ),
                                              onPressed: () {
                                                Map<String, dynamic>
                                                cartItems = {
                                                  'id': product['id'],
                                                  'title': product['title'],
                                                  'image': product['images'][0],
                                                  'price': product['price'],
                                                  'quantity': count,
                                                  'rating': product['rating'],
                                                };
                                                bool alreadyInCart = cartObject
                                                    .addtocart(cartItems);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      alreadyInCart
                                                          ? "Product quantity updated in cart!"
                                                          : "Product added to cart!",
                                                    ),
                                                    duration: Duration(milliseconds: 500),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Add to cart",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
