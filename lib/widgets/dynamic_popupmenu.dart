import 'package:coffeeapp/models/popupmenuitem_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DynamicPopUpMenuButton extends StatelessWidget {
  const DynamicPopUpMenuButton({
    super.key,
    required this.mainIconData,
    required this.onSelected,
    required this.listPopUpMenuItemModel,
  });

  final IconData mainIconData;
  final ValueChanged<String?> onSelected;
  final List<PopUpMenuItemModel> listPopUpMenuItemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton(
        icon: Icon(mainIconData),
        onSelected: onSelected,
        itemBuilder: (context) => listPopUpMenuItemModel.map((e) {
          return PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(e.iconData),
                Spacer(),
                Text("${e.title}"),
              ],
            ), // Assuming each item in listPopUpMenuItemModel has a 'text' property
            value: e
                .title, // Assuming each item in listPopUpMenuItemModel has a 'value' property
          );
        }).toList(),
      ),
    );
  }
}
