import 'package:coffeeapp/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
          ListView.builder(
            itemCount: 2,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 10),
                            color: Colors.grey.withOpacity(0.09),
                            blurRadius: 10.0,
                            spreadRadius: 4.0)
                      ]),
                  child: ListTile(
                    minVerticalPadding: 10,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    leading: Container(
                      width: 70,
                      height: 100,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green.withOpacity(0.2)),
                        child: Center(
                            child: FaIcon(
                                appIcons.getExpenseCategoryIcons('home'))),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(child: Text("Car rent Oct 2023")),
                        Text(
                          "Rs 5000",
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Balance",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            Text(
                              "Rs 500",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        Text(
                          "25 oct 4:52 PM",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
