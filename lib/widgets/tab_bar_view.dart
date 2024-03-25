import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/widgets/transaction_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TypeTabBar extends StatefulWidget {
  TypeTabBar(
      {super.key,
      required this.category,
      required this.monthYear,
      required this.isAdvance});

  final String category;
  final String monthYear;
  final bool isAdvance;

  @override
  State<TypeTabBar> createState() => _TypeTabBarState();
}

class _TypeTabBarState extends State<TypeTabBar> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var type = 'credit';
  var totalAmount;

  getTotalAmount() {
    totalAmount = 0;
    Query query = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('transactions')
        .orderBy('timeStamp', descending: true)
        .where('monthyear', isEqualTo: widget.monthYear)
        .where('type', isEqualTo: type)
        .where('isAdvance', isEqualTo: widget.isAdvance)
        .where('isDelete', isEqualTo: false);

    if (widget.category != '0') {
      query = query.where("categoryId", isEqualTo: widget.category);
    }

    query.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          totalAmount += int.parse(doc["amount"]);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTotalAmount();
  }

  @override
  void didUpdateWidget(TypeTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category ||
        oldWidget.monthYear != widget.monthYear ||
        oldWidget.isAdvance != widget.isAdvance) {
          getTotalAmount();
        }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
            length: 2,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      TabBar(
                          onTap: (value) => {
                                if (value == 0)
                                  {
                                    setState(() {
                                      type = 'credit';
                                      getTotalAmount();
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      type = 'debit';
                                      getTotalAmount();
                                    })
                                  }
                              },
                          tabs: [
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
                            type: type,
                            monthYear: widget.monthYear,
                            isAdvance: widget.isAdvance),
                        TransactionList(
                            category: widget.category,
                            type: type,
                            monthYear: widget.monthYear,
                            isAdvance: widget.isAdvance),
                      ]))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Total Amount: Rs ${NumberFormat('##,##,##,##,###').format(totalAmount)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
