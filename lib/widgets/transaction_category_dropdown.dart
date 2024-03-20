import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/models/category_model.dart';
import 'package:coffeeapp/utils/icons_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionCategoryDropDown extends StatefulWidget {
  TransactionCategoryDropDown(
      {super.key, this.cattype, required this.onChanged});

  final String? cattype;
  final ValueChanged<String?> onChanged;

  @override
  State<TransactionCategoryDropDown> createState() =>
      _TransactionCategoryDropDownState();
}

class _TransactionCategoryDropDownState
    extends State<TransactionCategoryDropDown> {
  var appIcons = AppIcons();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<CategoryModel> listCategoryModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categories')
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
      setState(() {
        listCategoryModel.insert(0, CategoryModel("0", 0, "All"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: widget.cattype,
        isExpanded: true,
        hint: Text("Select Category"),
        items: listCategoryModel
            .map((e) => DropdownMenuItem<String>(
                value: e.getId(),
                child: Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      e.getTitle(),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                )))
            .toList(),
        onChanged: widget.onChanged);
  }
}
