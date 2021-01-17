import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final ValueChanged<bool> valueChanged;
  CustomCheckbox(
      {this.isChecked,
      this.size,
      this.valueChanged,
      this.iconSize,
      this.selectedColor,
      this.selectedIconColor});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.valueChanged(_isSelected);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: _isSelected
                ? widget.selectedColor ?? Colors.blue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            border: _isSelected
                ? null
                : Border.all(
                    color: Colors.white,
                    width: 2.0,
                  )),
        width: widget.size ?? 30,
        height: widget.size ?? 30,
        child: _isSelected
            ? Icon(
                Icons.check,
                color: widget.selectedIconColor ?? Colors.white,
                size: widget.iconSize ?? 20,
              )
            : null,
      ),
    );
  }
}
