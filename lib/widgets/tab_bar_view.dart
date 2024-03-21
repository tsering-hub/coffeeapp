import 'package:coffeeapp/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class TypeTabBar extends StatefulWidget {
  TypeTabBar({super.key, required this.category, required this.monthYear});

  final String category;
  final String monthYear;

  @override
  State<TypeTabBar> createState() => _TypeTabBarState();
}

class _TypeTabBarState extends State<TypeTabBar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(tabs: [
                  Tab(
                    text: "Credit",
                  ),
                  Tab(
                    text: "Debit",
                  ),
                ]),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: TabBarView(children: [
                  TransactionList(
                      category: widget.category,
                      type: 'credit',
                      monthYear: widget.monthYear),
                  TransactionList(
                      category: widget.category,
                      type: 'debit',
                      monthYear: widget.monthYear),
                ]))
              ],
            )));
  }
}
