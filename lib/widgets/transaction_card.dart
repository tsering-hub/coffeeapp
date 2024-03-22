import 'package:coffeeapp/models/popupmenuitem_model.dart';
import 'package:coffeeapp/utils/icons_list.dart';
import 'package:coffeeapp/widgets/dynamic_popupmenu.dart';
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
    this.pos,
  });
  final int? pos;
  final dynamic data;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(data['timeStamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);
    int amount = int.parse(data['amount']);

    final listPopUpMenuItemModel = [
      PopUpMenuItemModel(Icons.edit, "Edit"),
      PopUpMenuItemModel(Icons.delete, "Delete")
    ];

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
          leading: Text(
            "${pos}. ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: data['type'] == 'credit'
                    ? Colors.green.shade900
                    : Colors.red.shade900),
          ),
          title: Row(
            children: [
              Expanded(
                  child: Text(
                "${data['title']}",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
              Text(
                "${data['type'] == 'credit' ? '+' : '-'} Rs ${NumberFormat('##,##,##,##,###').format(amount)}",
                style: TextStyle(
                    color:
                        data['type'] == 'credit' ? Colors.green : Colors.red),
              ),
              DynamicPopUpMenuButton(
                onSelected: (String? value) {
                  if (value == listPopUpMenuItemModel[0].title) {
                    onEditPressed();
                  }
                  if (value == listPopUpMenuItemModel[1].title) {
                    onDeletePressed();
                  }
                },
                listPopUpMenuItemModel: listPopUpMenuItemModel,
                mainIconData: Icons.more_vert,
              )
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['categoryId'],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  data['isAdvance']
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green.shade900,
                          ),
                          child: Text(
                            "Advance",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        )
                      : SizedBox(),
                  Spacer(),
                  Text(
                    formatedDate,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
