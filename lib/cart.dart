import 'package:ecom_api/provider.dart';
import 'package:ecom_api/buttom.dart';
import 'package:ecom_api/single_pro.dart';
import 'package:ecom_api/themeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'allPro.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  @override
  Widget build(BuildContext context) {
    final cartObject = Provider.of<CartProduct>(context);
    final themeProvider = Provider.of<ThemeProvider >(context);

    double grandTotal = 0;
    for (var product in cartObject.cartList) {
      grandTotal += product['price'] * product['quantity'];
    }

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
        title: Text("Shopping Cart", style: TextStyle(
            //color: Colors.white
        )),
        centerTitle: true,
      ),

      body: cartObject.cartList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your cart is empty",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w300)),
            SizedBox(height: 20),
            Image.asset("assets/cart1.png", height: 180, width: 200),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You may check out all the available products and buy some in the shop",
                maxLines: 2,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
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
      )
          :
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartObject.cartList.length,
              itemBuilder: (context, index) {
                var product = cartObject.cartList[index];

                if (product['quantity'] == null || product['quantity'] <= 0) {
                  product['quantity'] = 1;
                }

                double prices = product['price'].toDouble();
                int qty = product['quantity'];
                double total = prices * qty;


                return GestureDetector(
                  onTap: (){
                    Get.to(SinglePro(id: product['id']));
                  },
                  child: Card(
                    //color: Colors.white,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            height: 130,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
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


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Card(
                                     // color: Colors.grey[600],
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.circular(20),
                                      // ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.all(0.8),
                                              onPressed: () {
                                                setState(() {
                                                  if (product['quantity'] > 1) {
                                                    product['quantity']--;
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                CupertinoIcons.minus,
                                                //color: Colors.black,
                                                size: 14,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(0.10),
                                              child:
                                              Text(
                                                "${product['quantity'].toString()}",
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
                                                  product['quantity']++;
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
                                  ],
                                ),
                                Text("In Stock",style: TextStyle(
                                    color: Colors.lightGreen[400]),),

                                Table(
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [

                                      TableRow(children: [
                                        Text("Rating "),
                                        Text(": ${product['rating'].toString()}/5",style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),)
                                      ]),
                                    ],
                                  ),

                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total: ₹${total.toStringAsFixed(2)}",style: TextStyle(
                                      //color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),),
                                    Column(

                                      children: [

                                        TextButton(onPressed: (){
                                          setState(() {
                                            cartObject.cartList.removeAt(index);
                                          });
                                        }, child: Text("Remove",style: TextStyle(color: Colors.red[300]),))
                                      ],
                                    )
                                  ],
                                ),

                              ],
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
          SizedBox(width: 10), // spacing between buttons


        ],
      ),

      bottomNavigationBar: cartObject.cartList.isEmpty ?
          SizedBox(height: 10,)
      :
      SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            //color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Grand Total Container
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Grand Total: ",
                              style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                            Text(
                              "₹ ${grandTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),

                      // Buy Button
                      Expanded(
                        child: SizedBox(
                          height: 48, // consistent height
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.green[400],
                            ),
                            child: Text(
                              "Buy",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
