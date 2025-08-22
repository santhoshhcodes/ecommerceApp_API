// import 'dart:convert';
// import 'package:ecom_api/single_pro.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:http/http.dart' as http;
//
// class Fake extends StatefulWidget {
//   const Fake({super.key});
//
//   @override
//   State<Fake> createState() => _FakeState();
// }
//
// class _FakeState extends State<Fake> {
//   Future<List<dynamic>> getData() async {
//     try {
//       var apiRes = await http.get(Uri.parse("https://fakestoreapi.com/products"));
//       if (apiRes.statusCode == 200 || apiRes.statusCode == 201) {
//         var json = jsonDecode(apiRes.body);
//         print(json);
//         return json;
//       } else {
//         throw Exception("Error");
//       }
//     } catch (error) {
//       throw Exception(error);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Fake"),
//       ),
//       body: FutureBuilder(
//         future: getData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           } else if (snapshot.hasData) {
//             List<dynamic> productlist = snapshot.data!;
//             return ListView.builder(
//               itemCount: productlist.length,
//               itemBuilder: (BuildContext context, index) {
//                 var product = productlist[index];
//                 return GestureDetector(
//                   onTap: (){
//                     Get.to(SinglePro(id:product["id"],));
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.red[100]),
//                     child: Row(
//                       children: [
//                         Image.network(
//                           product['image'],
//                           height: 100,
//                           width: 100,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                               Icon(Icons.broken_image),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(child: Text(product['title']))
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Text("No data found");
//           }
//         },
//       ),
//     );
//   }
// }
