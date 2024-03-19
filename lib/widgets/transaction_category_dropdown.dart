import 'package:coffeeapp/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionCategoryDropDown extends StatefulWidget {
  TransactionCategoryDropDown(
      {super.key, this.cattype, required this.onChanged});

  final String? cattype;
  final ValueChanged<String?> onChanged;

  @override
  State<TransactionCategoryDropDown> createState() =>
      _TransactionCategoryDropDownState();
}

class _TransactionCategoryDropDownState
    extends State<TransactionCategoryDropDown> {
  var appIcons = AppIcons();
  List<Map<String, dynamic>> categorylist = [];

  var addCat = {
    "name": "All",
    "icon": FontAwesomeIcons.cartPlus,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      categorylist = appIcons.homeExpemseCategories;
      categorylist.insert(0, addCat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: widget.cattype,
        isExpanded: true,
        hint: Text("Select Category"),
        items: categorylist
            .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.black54,
                      size: 17,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      e['name'],
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                )))
            .toList(),
        onChanged: widget.onChanged);
  }
}
