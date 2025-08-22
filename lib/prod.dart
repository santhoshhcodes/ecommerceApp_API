// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class SingleProd extends StatefulWidget {
//
//   final int id;
//
//   const SingleProd({super.key, required this.id});
//
//   @override
//   State<SingleProd> createState() => _SingleProdState();
// }
//
//
// class _SingleProdState extends State<SingleProd> {
//
//   Future<dynamic> getData() async{
//     var id = widget.id;
//     var apiResp = await http.get(Uri.parse("https://fakestoreapi.com/products/${id}"));
//     var data = jsonDecode(apiResp.body);
//     return data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: getData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           } else if (snapshot.hasData) {
//             var product = snapshot.data;
//             return
//               Container(
//                 margin: EdgeInsets.all(10),
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(color: Colors.red[100]),
//                 child: Row(
//                   children: [
//                     Image.network(
//                       product['image'],
//                       height: 100,
//                       width: 100,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                           Icon(Icons.broken_image),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(child: Text(product['title']))
//                   ],
//                 ),
//               );
//
//           } else {
//             return Text("No data found");
//           }
//         },
//       ),
//     );
//   }
// }
