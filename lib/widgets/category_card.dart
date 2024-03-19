import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.pos,
    required this.title,
    required this.onPressed,
  });
  final int? pos;
  final String? title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
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
          leading: Text("${pos}."),
          title: Text("${title}"),
          trailing: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red.withOpacity(0.2)),
            child: Center(
                child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.delete,
                size: 20,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
