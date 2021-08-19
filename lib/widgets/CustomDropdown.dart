import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget{

  final String value;
  final String textHint;
  final Function onChanged;
  final List list;

  const CustomDropdown({
    Key key,
    @ required this.value,
    @ required this.textHint,
    @ required this.onChanged,
    @ required this.list
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.blue),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text(widget.textHint),
              value: widget.value,
              dropdownColor: Colors.blue,
              style: TextStyle(color: Colors.white),
              onChanged: widget.onChanged,
              selectedItemBuilder: (BuildContext context){
                return widget.list.map((value){
                  return Center(
                    child: Text(
                      widget.value,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList();
              },
              items: widget.list.map((valueItem){
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
        ) ,
      ),
    );
  }
}

