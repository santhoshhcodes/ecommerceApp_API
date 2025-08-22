import 'dart:convert';
import 'package:ecom_api/buttom.dart';
import 'package:ecom_api/cart.dart';
import 'package:ecom_api/categories.dart';
import 'package:ecom_api/login.dart';
import 'package:ecom_api/search.dart';
import 'package:ecom_api/single_pro.dart';
import 'package:ecom_api/themeProvider.dart';
import 'package:ecom_api/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'provider.dart';

class Allpro extends StatefulWidget {
  final String username;
  const Allpro({super.key, required this.username});

  @override
  State<Allpro> createState() => _AllproState();
}

class _AllproState extends State<Allpro> {
  final GlobalKey<ScaffoldState> Draw = GlobalKey<ScaffoldState>();

  int count = 1;

  //bool heart = true;
  Set<int> likedProducts = {};
  bool isSearching = false;
  TextEditingController search = TextEditingController();
  bool show = false;
  bool showThemeOptions = false;

  Future<List<dynamic>> getData() async {
    try {
      var apiRes = await http.get(Uri.parse("https://dummyjson.com/products"));
      if (apiRes.statusCode == 200 || apiRes.statusCode == 201) {
        var jsonBody = jsonDecode(apiRes.body);
        return jsonBody['products'];
      } else {
        throw Exception("Error: Failed to load data");
      }
    } catch (error) {
      throw Exception("Exception: $error");
    }
  }

  late Future<List<dynamic>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = getData();
  }

  void refreshProducts() {
    setState(() {
      futureProducts = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var cartObject = Provider.of<CartProduct>(context);
    final likedObject = Provider.of<WishlistProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: Draw,

      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
          DrawerHeader(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.white54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.username,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),]
    )
    ),

              // Menu items
              ListTile(
                leading: Icon(Icons.home, color: Colors.grey),
                title: Text("Home"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => buttomnav(username: 'username',)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.grey),
                title: Text("Cart"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Cart()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: Colors.grey),
                title: Text("Wishlist"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Wishlist()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.category, color: Colors.grey),
                title: Text("Category"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Categories()),
                  );
                },
              ),
              Spacer(),
        show
            ?  SizedBox(height: 10)
            : Column(
          children: [
            ListTile(
              leading:  Icon(Icons.brightness_6, color: Colors.grey),
              title:  Text("Theme"),
              trailing: Icon(
                showThemeOptions
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onTap: () {
                setState(() {
                  showThemeOptions = !showThemeOptions; // toggle expand
                });
              },
            ),

            if (showThemeOptions)
              Column(
                children: [
                  ListTile(
                    leading:  Icon(Icons.light_mode, color: Colors.orange),
                    title:  Text("Light Mode"),
                    trailing: themeProvider.isDarkMode == false
                        ?  Icon(Icons.check_box,
                        //color: Colors.green
                    )
                        : null,
                    onTap: () {
                      print("Light Mode selected");
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setTheme(false); // force Light
                    },
                  ),
                  ListTile(
                    leading:  Icon(Icons.dark_mode, color: Colors.blueGrey),
                    title:  Text("Dark Mode"),
                    trailing: themeProvider.isDarkMode == true
                        ?  Icon(Icons.check_box,
                        //color: Colors.green
                    )
                        : null,
                    onTap: () {
                      print("Dark Mode selected");
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setTheme(true); // force Dark
                    },
                  ),
                ],
              ),
          ],
        ),
             ListTile(
                  leading: Icon(Icons.login, color: Colors.red),
                  title: Text("Log-out", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    navigator?.push(MaterialPageRoute(builder: (builder)=> Login()));
                  },
                ),

            ],
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
         flexibleSpace: Container(
           decoration: BoxDecoration(
             gradient: LinearGradient(colors: [ Colors.black87, Colors.white30
             ],)
           ),
         ),
        leading: IconButton(
          onPressed: () {
            Draw.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu_outlined, color: Colors.white),
        ),
        title: isSearching
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: search,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search...",
                  ),
                ),
              )
            : Text("Shoppy", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Search()),
              );
            },
          ),

          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Get.to(Cart());
                },
              ),
              Positioned(
                top: 1,
                right: 1,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${cartObject.cartList.length}".toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          else if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          else if (snapshot.hasData) {
            List<dynamic> productList = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${widget.username}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "You are successfully logged in to your account",
                          style: TextStyle(fontSize: 14, color: Colors.grey
                          ,),

                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "New Arrivals",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75, // Adjust this to fix layout
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      var product = productList[index];
                      bool isInWishlist = likedObject.wish.any(
                        (item) => item['id'] == product['id'],
                      );
                      return GestureDetector(
                        onTap: () {
                          Get.to(SinglePro(id: product['id']));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                          elevation: 2,


                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                Stack(
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        product['images'][0],
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      ),
                                    ),
                                    // Heart icon on top-right
                                    Positioned(
                                      top: 1,
                                      left: 1,
                                      child: IconButton(
                                        onPressed: () {
                                          if (isInWishlist) {
                                            likedObject.removelistById(
                                              product['id'],
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Product removed from Wishlist!",
                                                ),
                                                duration: Duration(milliseconds: 500),
                                              ),
                                            );
                                          } else {
                                            likedObject.addtolist({
                                              'id': product['id'],
                                              'title': product['title'],
                                              'image': product['images'][0],
                                              'price': product['price'],
                                              'discountPercentage':
                                                  product['discountPercentage'],
                                              'quantity': count,
                                              'rating': product!['rating'],
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
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    // Optional: "New" label
                                    Positioned(
                                      top: 1,
                                      right: 1,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          //color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          "${product['discountPercentage'].toInt()}% OFF",

                                          style: TextStyle(
                                            //color: Colors.white,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
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
                                SizedBox(height: 8),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Text(
                                      "Rs. ${(product['price'] + (product['price'] * (product['discountPercentage'] / 100))).toInt()}",

                                      style: TextStyle(
                                        color: Colors.red[400],
                                        fontSize: 12,
                                        decoration:
                                            TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(width: 5),

                                    // Discounted Price
                                    Text(
                                      "Rs. ",
                                      style: TextStyle(
                                        //color: Colors.black,
                                      ),
                                    ),

                                    // Calculation: price - discount amount
                                    Text(
                                      "${(product['price']).toInt()}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // reduce padding

                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // shrink clickable area
                                  ),
                                  onPressed: () {
                                    Map<String, dynamic> cartItems = {
                                      'id': product['id'],
                                      'title': product['title'],
                                      'image': product['images'][0],
                                      'price': product['price'],
                                      'quantity': count,
                                      'rating': product!['rating'],
                                    };
                                    bool alreadyInCart = cartObject.addtocart(
                                      cartItems,
                                    );
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
                                    "Add to cart",
                                    style: TextStyle(
                                      //color: Colors.black,
                                      fontWeight: FontWeight.w600,
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
                ],
              ),
            );
          } else {
            return Center(child: Text("No products found"));
          }
        },
      ),
    );
  }
}
