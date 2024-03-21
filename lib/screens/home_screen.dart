import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/screens/login_screen.dart';
import 'package:coffeeapp/widgets/add_transaction_form.dart';
import 'package:coffeeapp/widgets/hero_card.dart';
import 'package:coffeeapp/widgets/transactions_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
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

  final userId = FirebaseAuth.instance.currentUser!.uid;
  _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddTransactionForm(),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade900,
      ),
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          HeroCard(
            userId: userId,
          ),
          TransactionsCard()
        ],
      )),
    );
  }
}
