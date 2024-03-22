import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/models/category_model.dart';
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
      required this.monthYear,
      required this.isAdvance});
  final String category;
  final String type;
  final String monthYear;
  final bool isAdvance;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var db = Db();
  List<CategoryModel> listCategoryModel = [];

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

      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];
      var transactionAmount = int.parse(transactionData!['amount']);

      if (transactionData['type'] == 'credit') {
        totalCredit -= transactionAmount;
      } else {
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
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categories')
        .where('isDelete', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      listCategoryModel.clear();
      querySnapshot.docs.forEach((doc) {
        var categoryModel =
            CategoryModel(doc["id"], doc["timeStamp"], doc["title"]);
        setState(() {
          listCategoryModel.add(categoryModel);
        });
      });
    });
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
        .where('isAdvance', isEqualTo: widget.isAdvance)
        .where('isDelete', isEqualTo: false);

    if (widget.category != '0') {
      query = query.where("categoryId", isEqualTo: widget.category);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No transactions found'));
        }

        var data = snapshot.data!.docs;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var cardData = data[index];
              return TransactionCard(
                pos: index + 1,
                data: cardData,
                onEditPressed: () {
                  _updatedialogBuilder(context, cardData);
                },
                onDeletePressed: () {
                  _deleteTransaction(cardData);
                },
                listCategoryModel: listCategoryModel,
              );
            },
          ),
        );
      },
    );
  }
}
