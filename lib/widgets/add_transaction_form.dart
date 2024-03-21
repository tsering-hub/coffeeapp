import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/services/db.dart';
import 'package:coffeeapp/utils/appvalidator.dart';
import 'package:coffeeapp/widgets/category_dropdown.dart';
import 'package:coffeeapp/widgets/checkbox_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key, this.transactionData});
  final QueryDocumentSnapshot<Object?>? transactionData;

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  bool isAdvance = false;
  var category;
  var isLoader = false;
  var isEdit = false;
  var db = Db();
  var appValidator = AppValidator();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();
      var id = uid.v4();

      String monthyear = DateFormat('MMM y').format(date);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];

      if (type == 'credit') {
        remainingAmount += amount;
        totalCredit += amount;
      } else {
        remainingAmount -= amount;
        totalDebit += amount;
      }

      if (widget.transactionData != null && isEdit == true) {
        if (widget.transactionData!["type"] == 'credit') {
          totalCredit -= int.parse(widget.transactionData!['amount']);
        } else {
          totalDebit -= int.parse(widget.transactionData!['amount']);
        }
        await db.updateUserDetails({
          "remainingAmount": totalCredit - totalDebit,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "updatedAt": timeStamp,
        }, context);

        var updateData = {
          'id': widget.transactionData!['id'],
          'title': titleEditController.text,
          'amount': amountEditController.text,
          'type': type,
          'categoryId': category,
          "isAdvance": isAdvance,
        };
        await db.updateTransactionDetails(updateData, context);
      } else {
        await db.updateUserDetails({
          "remainingAmount": totalCredit - totalDebit,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "updatedAt": timeStamp,
        }, context);

        var addData = {
          'id': id,
          'title': titleEditController.text,
          'amount': amountEditController.text,
          'type': type,
          'categoryId': category,
          "timeStamp": timeStamp,
          "monthyear": monthyear,
          "isAdvance": isAdvance,
          "isDelete": false,
        };

        await db.addTransactionDetails(addData, context);
      }

      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user!.uid)
      //     .collection('transactions')
      //     .doc(id)
      //     .set(data);

      Navigator.pop(context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.transactionData != null) {
      setState(() {
        isEdit = true;
        titleEditController.text = widget.transactionData?['title']!;
        amountEditController.text = widget.transactionData?['amount']!;
        category = widget.transactionData?['categoryId']!;
        type = widget.transactionData?['type']!;
        isAdvance = widget.transactionData?['isAdvance']!;
      });
    } else {
      setState(() {
        isEdit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleEditController,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: amountEditController,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
            SizedBox(
              height: 10,
            ),
            CategoryDropDown(
                cattype: category,
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      setState(() {
                        category = value;
                      });
                    }
                  });
                }),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
                value: type,
                items: [
                  DropdownMenuItem(
                    child: Text("Credit"),
                    value: "credit",
                  ),
                  DropdownMenuItem(
                    child: Text("Debit"),
                    value: "debit",
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                }),
            SizedBox(
              height: 10,
            ),
            CheckboxText(
                isChecked: isAdvance,
                txt: "Advance",
                onChanged: (bool? value) {
                  setState(() {
                    isAdvance = value!;
                  });
                }),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade900)),
                  onPressed: () {
                    isLoader ? print("Loading") : _submitForm();
                  },
                  child: isLoader
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Add Transaction",
                          style: TextStyle(color: Colors.white),
                        )),
            )
          ],
        ),
      ),
    );
  }
}
