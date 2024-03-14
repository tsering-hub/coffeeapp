import 'package:coffeeapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoader = false;

  Future<void> logOut() async {
    setState(() {
      isLogoutLoader = true;
    });
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );

    setState(() {
      isLogoutLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
              onPressed: logOut,
              icon: isLogoutLoader
                  ? Center(child: CircularProgressIndicator())
                  : Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ))
        ],
        title: Text(
          "Hello",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          width: double.infinity,
          color: Colors.blue.shade900,
          child: Column(
            children: [
              Text(
                "Total Balance",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2),
              ),
            ],
          )),
    );
  }
}
