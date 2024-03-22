import 'package:coffeeapp/models/category_model.dart';
import 'package:coffeeapp/models/popupmenuitem_model.dart';
import 'package:coffeeapp/utils/icons_list.dart';
import 'package:coffeeapp/widgets/dynamic_popupmenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatefulWidget {
  TransactionCard({
    super.key,
    required this.data,
    required this.onEditPressed,
    required this.onDeletePressed,
    this.pos,
    required this.listCategoryModel,
  });
  final int? pos;
  final dynamic data;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final List<CategoryModel> listCategoryModel;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  var appIcons = AppIcons();
  var categoryName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.listCategoryModel.length; i++) {
      if (widget.data['categoryId'].toString() ==
          widget.listCategoryModel[i].id) {
        setState(() {
          categoryName = widget.listCategoryModel[i].title;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(widget.data['timeStamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);
    int amount = int.parse(widget.data['amount']);

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
            "${widget.pos}. ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.data['type'] == 'credit'
                    ? Colors.green.shade900
                    : Colors.red.shade900),
          ),
          title: Row(
            children: [
              Expanded(
                  child: Text(
                "${widget.data['title']}",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
              Text(
                "${widget.data['type'] == 'credit' ? '+' : '-'} Rs ${NumberFormat('##,##,##,##,###').format(amount)}",
                style: TextStyle(
                    color: widget.data['type'] == 'credit'
                        ? Colors.green
                        : Colors.red),
              ),
              DynamicPopUpMenuButton(
                onSelected: (String? value) {
                  if (value == listPopUpMenuItemModel[0].title) {
                    widget.onEditPressed();
                  }
                  if (value == listPopUpMenuItemModel[1].title) {
                    widget.onDeletePressed();
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
                categoryName ?? "others",
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  widget.data['isAdvance']
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
