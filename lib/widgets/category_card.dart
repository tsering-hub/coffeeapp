import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.pos,
    required this.title,
    required this.onEditPressed,
    required this.onDeletePressed,
  });
  final int? pos;
  final String? title;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("${widget.pos}. ")),
                Expanded(flex: 5, child: Text("${widget.title}")),
                Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green.withOpacity(0.2)),
                          child: Center(
                              child: IconButton(
                            onPressed: widget.onEditPressed,
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          )),
                        ),
                        Spacer(),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red.withOpacity(0.2)),
                          child: Center(
                              child: IconButton(
                            onPressed: widget.onDeletePressed,
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                          )),
                        ),
                      ],
                    ))
              ],
            ),
          )

          // ListTile(
          //   leading: Text("${widget.pos}."),
          //   title: Text("${widget.title}"),
          //   trailing: Container(
          //     width: 50,
          //     height: 50,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Colors.green.withOpacity(0.2)),
          //     child: Center(
          //         child: IconButton(
          //       onPressed: widget.onEditPressed,
          //       icon: Icon(
          //         Icons.edit,
          //         size: 20,
          //       ),
          //     )),
          //   ),
          // ),
          ),
    );
  }
}
