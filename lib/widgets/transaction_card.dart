import 'package:coffeeapp/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
  });

  final dynamic data;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(data['timeStamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Dismissible(
        direction: DismissDirection.horizontal,
        key: Key(data['id']),
        background: Container(),
        secondaryBackground: Container(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('updated')),
                  );
                  // Perform edit action here
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('deleted')),
                  );

                  // Perform delete action here
                },
              ),
            ],
          ),
        ),
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
              width: 70,
              height: 100,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: data['type'] == 'credit'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2)),
                child: Center(child: FaIcon(FontAwesomeIcons.utensils)),
              ),
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
                Row(
                  children: [
                    Text(
                      "Balance",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacer(),
                    Text(
                      "Rs ${data['remainingAmount']}",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Text(
                  formatedDate,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
