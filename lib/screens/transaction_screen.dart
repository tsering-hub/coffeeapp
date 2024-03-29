import 'package:coffeeapp/screens/change_password_screen.dart';
import 'package:coffeeapp/widgets/category_dropdown.dart';
import 'package:coffeeapp/widgets/category_list.dart';
import 'package:coffeeapp/widgets/checkbox_text.dart';
import 'package:coffeeapp/widgets/tab_bar_view.dart';
import 'package:coffeeapp/widgets/time_line_month.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isAdvance = false;
  var category = "0";
  var monthYear = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthYear = DateFormat('MMM y').format(now);
    });
  }

  openChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
              onPressed: openChangePassword,
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
        title: Text(
          "Expansive",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          TimeLineMonth(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  monthYear = value;
                });
              }
            },
          ),
          // CategoryList(
          //   onChanged: (String? value) {
          //     if (value != null) {
          //       setState(() {
          //         category = value;
          //       });
          //     }
          //   },
          // ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: CategoryDropDown(
                from: "transactionscreen",
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CheckboxText(
                isChecked: isAdvance,
                txt: "Advance",
                onChanged: (bool? value) {
                  setState(() {
                    isAdvance = value!;
                  });
                }),
          ),
          TypeTabBar(
            category: category,
            monthYear: monthYear,
            isAdvance:isAdvance
          )
        ],
      ),
    );
  }
}
