import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeeapp/services/db.dart';
import 'package:coffeeapp/widgets/add_category_form.dart';
import 'package:coffeeapp/widgets/category_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  var db = Db();

  _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddCategoryForm(),
          );
        });
  }

  _updatedialogBuilder(
      BuildContext context, QueryDocumentSnapshot<Object?>? categoryData) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddCategoryForm(categoryData: categoryData),
          );
        });
  }

  _deleteCategory(String? id) async {
    try {
      var updateData = {
        "id": id,
        "isDelete": true,
      };
      await db.updateCategoryDetails(updateData, context);
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
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _dialogBuilder(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue.shade900,
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: Text(
            'Category',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection('categories')
              .where('isDelete', isEqualTo: false)
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No category found'));
            }

            var data = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var cardData = data[index];
                return CategoryCard(
                  pos: index + 1,
                  title: cardData['title'],
                  onEditPressed: () {
                    _updatedialogBuilder(context, cardData);
                  },
                  onDeletePressed: () {
                    _deleteCategory(cardData['id']);
                  },
                );
              },
            );
          },
        ));
  }
}
