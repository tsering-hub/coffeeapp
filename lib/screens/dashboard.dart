import 'package:coffeeapp/screens/home_screen.dart';
import 'package:coffeeapp/screens/login_screen.dart';
import 'package:coffeeapp/screens/transaction_screen.dart';
import 'package:coffeeapp/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 

  int currentIndex = 0;

  var pageViewList = [HomeScreen(), TransactionScreen()];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (int value) {
            setState(() {
              currentIndex = value;
            });
          }),
     
      body: pageViewList[currentIndex],
    );
  }
}
