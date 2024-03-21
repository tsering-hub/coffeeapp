import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/services/db.dart';
import 'package:coffeeapp/widgets/add_transaction_form.dart';
import 'package:coffeeapp/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  TransactionList(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});
  final String category;
  final String type;
  final String monthYear;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var db = Db();

  _updatedialogBuilder(
      BuildContext context, QueryDocumentSnapshot<Object?>? transactionData) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddTransactionForm(transactionData: transactionData),
          );
        });
  }

  _deleteTransaction(String? id) async {
    try {
      var updateData = {
        "id": id,
        "isDelete": true,
      };

      await db.updateTransactionDetails(updateData, context);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to delete'),
              content: Text(e.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('transactions')
        .orderBy('timeStamp', descending: true)
        .where('monthyear', isEqualTo: widget.monthYear)
        .where('type', isEqualTo: widget.type)
        .where('isDelete', isEqualTo: false);

    if (widget.category != '0') {
      query = query.where("categoryId", isEqualTo: widget.category);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.limit(150).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No transactions found'));
        }

        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            var cardData = data[index];
            return TransactionCard(
              data: cardData,
              onEditPressed: () {
                _updatedialogBuilder(context, cardData);
              },
              onDeletePressed: () {
                _deleteTransaction(cardData['id']);
              },
            );
          },
        );
      },
    );
  }
}
