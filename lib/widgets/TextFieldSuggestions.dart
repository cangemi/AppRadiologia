import 'package:flutter/material.dart';

class TextFieldSuggestions extends StatefulWidget {
  final List<String> list;
  final TextEditingController controller;
  final Function onChange;
  final Function returnedValue;
  final String labelText;
  final Color textSuggetionsColor;
  final Color suggetionsBackgroundColor;
  final Color outlineInputBorderColor;
  const TextFieldSuggestions(
      {Key key,
      this.list,
      this.controller,
      this.onChange,
      this.labelText,
      this.textSuggetionsColor,
      this.suggetionsBackgroundColor,
      this.outlineInputBorderColor,
      this.returnedValue})
      : super(key: key);

  @override
  _TextFieldSuggestionsState createState() => _TextFieldSuggestionsState();
}

class _TextFieldSuggestionsState extends State<TextFieldSuggestions> {
  String Captalize(String text) {
    String textCapitalized =
        text[0].toUpperCase() + text.substring(1).toLowerCase();
    return textCapitalized;
  }

  @override
  void dispose() {
    super.dispose();
    widget.list.clear();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.2,
          right: MediaQuery.of(context).size.width * 0.2),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: widget.labelText,
              fillColor: widget.outlineInputBorderColor,
            ),
            scrollPadding: EdgeInsets.only(bottom: 100),
            controller: widget.controller,
            onChanged: widget.onChange,
            onSubmitted: (String value) {
              if (value != "") {
                setState(() {
                  widget.controller.text = Captalize(widget.list[0]);
                  widget.list.clear();
                });
                widget.returnedValue(widget.controller.text.toLowerCase());
              } else {
                setState(() {
                  widget.controller.text = "";
                });
                widget.returnedValue(widget.controller.text);
              }
            },
          ),
          widget.list.length == 0
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: widget.suggetionsBackgroundColor),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(Captalize(widget.list[index]),
                              style:
                                  TextStyle(color: widget.textSuggetionsColor)),
                          onTap: () {
                            setState(() {
                              widget.controller.text =
                                  Captalize(widget.list[index]);
                              widget.list.clear();
                            });
                            widget.returnedValue(
                                widget.controller.text.toLowerCase());
                            FocusScope.of(context).unfocus();
                          },
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
