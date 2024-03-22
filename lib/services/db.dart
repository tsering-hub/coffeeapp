import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Db {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var uuid = Uuid();

// ======================User
  Future<void> addUser(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userId)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to add'),
              content: Text(error.toString()),
            );
          });
    });
  }

  Future<void> updateUserDetails(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userId)
        .update(data)
        .then((value) => print("User details updated"))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to update'),
              content: Text(error.toString()),
            );
          });
    });
  }

// ======================Category
  Future<void> addCategoryDetails(title, context) async {
    final user = FirebaseAuth.instance.currentUser;
    var id = uuid.v4();
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    var cdata = {
      'id': id,
      'title': title,
      "timeStamp": timeStamp,
      "isDelete": false,
    };

    await users
        .doc(user!.uid)
        .collection('categories')
        .doc(id)
        .set(cdata)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Category Added')),
            ))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to add'),
              content: Text(error.toString()),
            );
          });
    });
  }

  Future<void> updateCategoryDetails(data, context) async {
    final user = FirebaseAuth.instance.currentUser;
    await users
        .doc(user!.uid)
        .collection('categories')
        .doc(data['id'])
        .update(data)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['isDelete'] == true
                ? 'Category deleted'
                : 'Category updated'))))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to update'),
              content: Text(error.toString()),
            );
          });
    });
  }

  // Future<void> deleteCategoryById(id, context) async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   await users
  //       .doc(userId)
  //       .collection('categories')
  //       .doc(id)
  //       .delete()
  //       .then((value) => // Handle delete
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('deleted')),
  //           ))
  //       .catchError((error) {
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text('Failed to delete'),
  //             content: Text(error.toString()),
  //           );
  //         });
  //   });
  // }

// ======================Transaction
  Future<void> addTransactionDetails(data, context) async {
    final user = FirebaseAuth.instance.currentUser;

    await users
        .doc(user!.uid)
        .collection('transactions')
        .doc(data['id'])
        .set(data)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Category Added')),
            ))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to add'),
              content: Text(error.toString()),
            );
          });
    });
  }

  Future<void> updateTransactionDetails(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userId)
        .collection('transactions')
        .doc(data['id'])
        .update(data)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(data['isDelete'] == true
                      ? 'Transaction deleted'
                      : 'Transaction updated')),
            ))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to update'),
              content: Text(error.toString()),
            );
          });
    });
  }

  // Future<void> deleteTransactionById(id, context) async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   await users
  //       .doc(userId)
  //       .collection('transactions')
  //       .doc(id)
  //       .delete()
  //       .then((value) => // Handle delete
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text('deleted')),
  //           ))
  //       .catchError((error) {
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text('Failed to delete'),
  //             content: Text(error.toString()),
  //           );
  //         });
  //   });
  // }
}
