import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/services/db.dart';
import 'package:coffeeapp/utils/icons_list.dart';
import 'package:coffeeapp/widgets/add_transaction_form.dart';
import 'package:coffeeapp/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

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
          RecentTransactionsList()
        ],
      ),
    );
  }
}

class RecentTransactionsList extends StatefulWidget {
  RecentTransactionsList({
    super.key,
  });

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
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

  _deleteTransaction(QueryDocumentSnapshot<Object?>? transactionData) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];
      var transactionAmount = int.parse(transactionData!['amount']);

      if (transactionData['type'] == 'credit') {
        remainingAmount -= transactionAmount;
        totalCredit -= transactionAmount;
      } else {
        remainingAmount += transactionAmount;
        totalDebit -= transactionAmount;
      }

      await db.updateUserDetails({
        "remainingAmount": totalCredit - totalDebit,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updatedAt": timeStamp,
      }, context);

      var updateData = {
        "id": transactionData['id'],
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('transactions')
          .where('isDelete', isEqualTo: false)
          .orderBy('timeStamp', descending: true)
          .limit(10)
          .snapshots(),
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
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var cardData = data[index];
            return TransactionCard(
              data: cardData,
              onEditPressed: () {
                _updatedialogBuilder(context, cardData);
              },
              onDeletePressed: () {
                _deleteTransaction(cardData);
              },
            );
          },
        );
      },
    );
  }
}
