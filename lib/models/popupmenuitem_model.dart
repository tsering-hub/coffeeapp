import 'package:flutter/material.dart';

class PopUpMenuItemModel {
  final IconData iconData;
  final String title;

  PopUpMenuItemModel(this.iconData, this.title);

  getIconData() {
    return iconData;
  }

  getTitle() {
    return title;
  }
}
