import 'dart:convert';
import 'package:ecom_api/single_pro.dart';
import 'package:ecom_api/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List products = [];
  bool isLoading = false;

  Future<void> fetchSearchResults(String value) async {
    if (value.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http
          .get(Uri.parse("https://dummyjson.com/products/search?q=$value"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allProducts = data['products'];


        final filtered = allProducts.where((product) {
          return product['title']
              .toString()
              .toLowerCase()
              .startsWith(value.toLowerCase());
        }).toList();

        setState(() {
          products = filtered;
        });
      }
    } catch (error) {
      throw Exception(error);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [ Colors.black87, Colors.white30
              ],)
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                      onPressed: () =>
                          fetchSearchResults(searchController.text),
                      icon: Icon(Icons.search))),
              onChanged: (value) {
                fetchSearchResults(value);
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())

          : searchController.text.isEmpty
        ? Center(child: Text("Search..."),)
        :products.isEmpty
           ? Center(child: Text('No result...'))

          : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Get.to(SinglePro(id: product['id']));
              },
              child: ListTile(
                leading: Image.network(
                  product['thumbnail'],
                  width: 50,
                  errorBuilder: (context, error, stack) =>
                      Icon(Icons.image_not_supported),
                ),
                title: Text(product['title']),

              ),
            );
          }
          )

    
    );
  }
}
