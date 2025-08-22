import 'dart:convert';
import 'dart:ui';
import 'package:ecom_api/buttom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final valid = GlobalKey<FormState>();
  bool _view = false;
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController gender = TextEditingController();

  String? selectedGender;

  Future<http.Response> postData() async {
    try {
      var response = await http.post(
        Uri.parse("http://92.205.109.210:8070/api/signup"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({
          "name": name.text.trim(),
          "pwd": pass.text.trim(),
          "gender": selectedGender ?? "",
          "mail": mail.text.trim(),
        }),
      );

      // print("Status: ${response.statusCode}");
      // print("Body: ${response.body}");

      return response;
    } catch (error) {
      throw Exception(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          "Sign-Up",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: valid,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            SingleChildScrollView(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 70),
                        Container(
                          height: 150,
                          width: 350,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/login.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 340,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Welcome Back!!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Please sign up to Login",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 25),

                              TextFormField(
                                controller: name,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (RegExp(
                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]',
                                  ).hasMatch(value!)) {
                                    return "Please enter a valid name";
                                  } else if (name.text.isEmpty) {
                                    return "please enter the name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Your Name",
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.white70,
                                  ),
                                  /*prefixIcon: Icon(icon, color: Colors.white70),
                                  suffixIcon: suffix,
                                  hintText: hint,*/
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: pass,
                                obscureText: !_view,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter the password";
                                  }
                                  if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                  ).hasMatch(value)) {
                                    return "Password must be 8+ chars with letters, numbers & special char.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Your Password",
                                  icon: Icon(Icons.lock, color: Colors.white70),
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _view = !_view;
                                      });
                                    },
                                    icon: Icon(
                                      _view
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: mail,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your email";
                                  }

                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },

                                decoration: InputDecoration(
                                  hintText: "Enter Your Email",
                                  icon: const Icon(
                                    Icons.email,
                                    color: Colors.white70,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white54,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Gender",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(width: 30),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "male",
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        "Male",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "female",
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        "Female",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                ],
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  if (valid.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Submitting..."),
                                        duration: Duration(milliseconds: 500),
                                      ),
                                    );
                                    var response = await postData();

                                    if (response.statusCode == 200) {
                                      // Success (depends on your API)
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Signed up successfully",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      );
                                    } else {
                                      // Failure (user exists, bad password, etc.)
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Sign in failed: ${response.body}",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },

                                child: Text(
                                  "Sign-Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
