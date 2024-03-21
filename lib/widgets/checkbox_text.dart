import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxText extends StatefulWidget {
  const CheckboxText(
      {super.key,
      required this.isChecked,
      required this.txt,
      required this.onChanged});
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final String txt;

  @override
  State<CheckboxText> createState() => _CheckboxTextState();
}

class _CheckboxTextState extends State<CheckboxText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: widget.isChecked,
            onChanged: widget.onChanged,
          ),
          Expanded(
            child: Text(
              "${widget.txt}",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
