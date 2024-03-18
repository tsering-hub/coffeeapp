import 'package:coffeeapp/widgets/category_list.dart';
import 'package:coffeeapp/widgets/time_line_month.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expansive"),
      ),
      body: Column(
        children: [
          TimeLineMonth(onChanged: (String? value) {  },),
          CategoryList(onChanged: (String? value) {  },),
          Text("Transaction"),
        ],
      ),
    );
  }
}
