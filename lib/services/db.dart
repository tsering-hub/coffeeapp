import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
        .then((value) => print("User password updated"))
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

  Future<void> updateCategoryDetails(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userId)
        .collection('categories')
        .doc(data['id'])
        .update(data)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Category password updated')),
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

  Future<void> deleteCategoryById(id, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users
        .doc(userId)
        .collection('categories')
        .doc(id)
        .delete()
        .then((value) => // Handle delete
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('deleted')),
            ))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to delete'),
              content: Text(error.toString()),
            );
          });
    });
  }
}
