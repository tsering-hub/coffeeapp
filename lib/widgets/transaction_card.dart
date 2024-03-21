import 'package:coffeeapp/utils/icons_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final dynamic data;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(data['timeStamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  color: Colors.grey.withOpacity(0.09),
                  blurRadius: 10.0,
                  spreadRadius: 4.0)
            ]),
        child: ListTile(
          minVerticalPadding: 10,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
          leading: Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: data['type'] == 'credit'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2)),
            child: Center(
                child: Text(
              "data",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: data['type'] == 'credit'
                      ? Colors.green.shade900
                      : Colors.red.shade900),
            )),
          ),
          title: Row(
            children: [
              Expanded(child: Text("${data['title']}")),
              Text(
                "${data['type'] == 'credit' ? '+' : '-'} Rs ${data['amount']}",
                style: TextStyle(
                    color:
                        data['type'] == 'credit' ? Colors.green : Colors.red),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatedDate,
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                        child: IconButton(
                      onPressed: onEditPressed,
                      icon: Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.blue.shade900,
                      ),
                    )),
                  ),
                  Expanded(
                    child: Center(
                        child: IconButton(
                      onPressed: onDeletePressed,
                      icon: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.red.shade900,
                      ),
                    )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
