import 'package:coffeeapp/screens/dashboard.dart';
import 'package:coffeeapp/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors
class AuthServerice {
  var db = Db();
  createUser(data, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      await db.addUser(data, context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign Up Failed'),
              content: Text(e.toString()),
            );
          });
    }
  }

  login(data, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login Error'),
              content: Text(e.toString()),
            );
          });
    }
  }

  changePassword(data, context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final email = currentUser.email;
      try {
        var cred = EmailAuthProvider.credential(
            email: email.toString(), password: data['oldpassword']);

        await currentUser.reauthenticateWithCredential(cred).then((value) {
          currentUser.updatePassword(data['newpassword']);
        });
        await db.updateUserDetails({'password': data['newpassword']}, context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Login Error'),
                content: Text(e.toString()),
              );
            });
      }
    }
  }
}
