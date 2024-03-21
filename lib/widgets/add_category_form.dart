import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/services/db.dart';
import 'package:coffeeapp/utils/appvalidator.dart';
import 'package:coffeeapp/utils/icons_list.dart';
import 'package:coffeeapp/widgets/category_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key, this.categoryData});
  final QueryDocumentSnapshot<Object?>? categoryData;

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  var isLoader = false;
  var isEdit = false;

  var appValidator = AppValidator();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var db = Db();
  var titleEditController = TextEditingController();
  // var uid = Uuid();

  var appIcons = AppIcons();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;

      if (widget.categoryData != null && isEdit == true) {
        var data = {
          "id": widget.categoryData?['id']!,
          'title': titleEditController.text,
        };
        await db.updateCategoryDetails(data, context);
      } else {
        await db.addCategoryDetails(titleEditController.text, context);
      }

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
    if (widget.categoryData != null) {
      setState(() {
        isEdit = true;
        titleEditController.text = widget.categoryData?['title']!;
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
                          isEdit ? "Update Category" : "Add Category",
                          style: TextStyle(color: Colors.white),
                        )),
            )
          ],
        ),
      ),
    );
  }
}
