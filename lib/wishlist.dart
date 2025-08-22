import 'package:ecom_api/single_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import 'provider.dart';
import 'buttom.dart';

class Wishlist extends StatefulWidget {
  //final List<Map<String, dynamic>> products;
   const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  int count = 1;
  Set<int> likedProducts = {

  };
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final cartObject = Provider.of<CartProduct>(context);
    final likedObject = Provider.of<WishlistProvider>(context);

    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ Colors.black87, Colors.white30
              ],)
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>buttomnav(username: 'username',)));
          },
          icon: Icon(Icons.arrow_back_ios,
              //color: Colors.white
          ),
        ),
        title: Text("Wishlist", style: TextStyle(
            //color: Colors.white
        )),
        centerTitle: true,
      ),
      body:
      likedObject.wish.isEmpty
          ? Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Wishlist is empty",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
            SizedBox(height: 20),
            Image.asset("assets/wish2.png",
                fit: BoxFit.fill,
                height: 180, width: 200),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You may check out all the available products and buy some in the shop",
                maxLines: 2,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(
                   // color: Colors.grey
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>buttomnav(username: 'username',)));
              },
              style: ElevatedButton.styleFrom(
                  //backgroundColor: Colors.black,
                  padding: EdgeInsets.all(20)),
              child: Text("Return to shop", style: TextStyle(
                  //color: Colors.white
              )),
            )
          ],
        ),
      ) :
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: likedObject.wish.length,
              itemBuilder: (context, index) {
                var product = likedObject.wish[index];
                bool isInWishlist =
                likedObject.wish.any((item) => item['id'] == product['id']);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> SinglePro(id: product['id'])));
                  },
                  child: Card(
                    //color: Colors.white,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 130,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Image.network(
                                  product['image'],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['title'],
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Table(
                                        columnWidths: const {
                                          0: IntrinsicColumnWidth(),
                                          1: FlexColumnWidth(),
                                        },
                                        children: [
                                          TableRow(children: [
                                            Text("Price "),
                                            Text(": ₹${product['price'].toString()}",
                                              style: TextStyle(fontWeight: FontWeight.bold),),
                                          ]),
                                          TableRow(children: [
                                            Text("Rating "),
                                            Text(": ${product['rating'].toString()}/5",style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),)
                                          ]),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text("In Stock",style: TextStyle(color: Colors.lightGreen[400]),

                                      ),
                                    ),



                                  ],
                                ),
                              ),

                            ],
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: IconButton(
                              onPressed: () {
                                likedObject.removelistById(product['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Product removed from Wishlist!")),
                                );
                              },
                              icon: Icon(CupertinoIcons.heart_fill, color: Colors.red),
                              splashRadius: 20,
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
      )
    );
  }
}
