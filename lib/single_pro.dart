import 'dart:convert';
import 'package:ecom_api/buttom.dart';
import 'package:ecom_api/provider.dart';
import 'package:ecom_api/themeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'allPro.dart';
import 'cart.dart';

class SinglePro extends StatefulWidget {
  final int id;
  const SinglePro({super.key, required this.id});

  @override
  State<SinglePro> createState() => SingleProState();
}

class SingleProState extends State<SinglePro> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? error;
  int count = 1;
  Set likedProduct ={};



  @override
  void initState() {
    super.initState();
    fetchProduct(); // Call once
  }

  Future<void> fetchProduct() async {
    try {
      var id = widget.id;
      var res = await http.get(Uri.parse('https://dummyjson.com/products/$id'));

      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          product = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load product";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var cartObject = Provider.of<CartProduct>(context);
    var likedObject = Provider.of<WishlistProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isInWishlist = false;
    if (product != null) {
      isInWishlist = likedObject.wish.any((item) => item['id'] == product!['id']);
    }

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
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                //color: Colors.white
            )),
        title: Text("Products", style: TextStyle(
            //color: Colors.white
        )),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              //color: Colors.grey[200]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product!['title'],
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.black12,
                    ),
                    child: Image.network(
                      product!['images'][0],
                      height: 250,
                      width: 280,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    ),
                  ),
                ),

              SizedBox(height: 10),
              Text(
                product!['title'],
                style: TextStyle(
                    //color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  product!['description'],
                  style: TextStyle(
                     // color: Colors.black
                  ),
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Best Seller",
                    style: TextStyle(
                        //color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.sparkles,
                    color: Colors.orangeAccent,
                  ),
                  Expanded(
                    child: Text(
                      " Selling fast! 55 people Have this in their cart",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Rs. ${(product!['price'] + (product!['price'] * (product!['discountPercentage'] / 100))).toStringAsFixed(2)}",
                    style: TextStyle(
                     // color: Colors.black,
                        fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough
                    ),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    children: [
                      Text("- ${product!['discountPercentage'].toInt()} off",
                        style: TextStyle(
                            fontSize: 10,
                          color: Colors.red[800]
                        ),),
                      SizedBox(height: 10,)

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Text("Rs.", style: TextStyle(fontSize: 25)),
                  ),
                  Text(
                    " ${(product!['price']).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.green[300],
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(width: 4,),

                ],
              ),
              SizedBox(height: 10),
              Text("Quantity",
                  style: TextStyle(
                      //color: Colors.black
                    )
              ),
              Card(
                elevation: 4,
                //color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(0.8),
                        onPressed: () {
                          if (count > 1) {
                            setState(() {
                              count--;
                            });
                          }
                        },
                        icon: Icon(
                          CupertinoIcons.minus,
                          //color: Colors.black,
                          size: 14,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.10),
                        child: Text(
                          "$count",
                          style: TextStyle(
                           // color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0.8),
                        onPressed: () {
                          setState(() {
                            count++;
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.plus,
                          //color: Colors.black,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> cartItems = {
                        'id': product!['id'],
                        'title': product!['title'],
                        'image': product!['images'][0],
                        'price': product!['price'],
                        'quantity': count,
                        'rating' : product!['rating'],
                      };
                      bool alreadyInCart = cartObject.addtocart(cartItems);
                      ScaffoldMessenger.of(context).showSnackBar(
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
                      "Add to Cart - Rs.${(product!['price'] * count).toStringAsFixed(2)}",
                      style:  TextStyle(
                        //color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.black,
                      padding:  EdgeInsets.symmetric(
                        horizontal: 65, vertical: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.only(left: 8.0, right: 0.8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (isInWishlist) {
                              likedObject.removelistById(product!['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Product removed from Wishlist!")),
                              );
                            } else {
                              likedObject.addtolist({
                                'id': product!['id'],
                                'title': product!['title'],
                                'image': product!['images'][0],
                                'price': product!['price'],
                                'discountPercentage': product!['discountPercentage'],
                                'quantity': count,
                                'rating' : product!['rating'],
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Product added to Wishlist!"),
                                duration: Duration(milliseconds: 500),
                              ),
                              );
                            }
                          },
                          icon: Icon(
                            isInWishlist
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child:  Text(
                  "BUY IT NOW",
                  style: TextStyle(
                    //color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:  EdgeInsets.symmetric(
                    horizontal: 130, vertical: 20,
                  ),
                ),
              ),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Column(
                children: List.generate(product!['reviews'].length, (index) {
                  var review = product!['reviews'][index];
                  return Stack(
                    children: [
                      Card(
                        elevation: 2,
                        //color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                columnWidths: const {
                                  0: IntrinsicColumnWidth(),
                                  1: FlexColumnWidth(),
                                },
                                children: [
                                  TableRow(children: [
                                    Text("User"),
                                    Text(": ${review['reviewerName']}")
                                  ]),
                                  TableRow(children: [
                                    Text("UserID"),
                                    Text(": ${review['reviewerEmail']}")
                                  ]),
                                  TableRow(children: [
                                    Text("Comment"),
                                    Text("")
                                  ]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                review['comment'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  //color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${product!['rating']} / 5',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.star, color: Colors.yellow[700]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),



            ],
          ),
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Container(
      //     padding: EdgeInsets.all(8),
      //     color: Colors.white,
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min, // makes it wrap its content
      //       children: [
      //
      //       ],
      //     ),
      //   ),
      // ),



    );

  }

}
