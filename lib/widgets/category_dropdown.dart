import 'package:coffeeapp/utils/icons_list.dart';
import 'package:flutter/material.dart';

class CategoryDropDown extends StatelessWidget {
  CategoryDropDown({super.key, this.cattype, required this.onChanged});

  final String? cattype;
  final ValueChanged<String?> onChanged;

  var appIcons = AppIcons();
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: cattype,
        isExpanded: true,
        hint: Text("Select Category"),
        items: appIcons.homeExpemseCategories
            .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      e['name'],
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                )))
            .toList(),
        onChanged: onChanged);
  }
}