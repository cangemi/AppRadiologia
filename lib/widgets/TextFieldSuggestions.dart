import 'package:flutter/material.dart';

class TextFieldSuggestions extends StatefulWidget {
  final List<String> list;
  final Function returnedValue;
  final String labelText;
  final Color textSuggetionsColor;
  final Color suggetionsBackgroundColor;
  final Color outlineInputBorderColor;
  const TextFieldSuggestions(
      {Key key,
        this.list,
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
  String captalize(String text) {
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
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2),
        child:RawAutocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue){
            if(textEditingValue.isComposingRangeValid){
              return widget.list.where((String option){
                return option.contains(textEditingValue.text.toLowerCase());
              }
              );
            }else{
              List<String> emptyList = [];
              return emptyList;
            }
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted
              ){
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              scrollPadding: EdgeInsets.only(bottom:200 ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: widget.labelText,
                fillColor: widget.outlineInputBorderColor,
              ),
              onFieldSubmitted: (String value){
                if(value.isNotEmpty){
                  onFieldSubmitted();
                  widget.returnedValue(textEditingController.text);
                }
              },

            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String>onSelected, Iterable<String> options){
            return Container(
              margin: EdgeInsets.only(top: 2,
                  right: MediaQuery.of(context).size.width * 0.4),
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: 2,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: options.length == 1 ? 85 : options.length == 2? 150 :200,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index){
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: (){
                              onSelected(option);
                              widget.returnedValue(option);
                              FocusScope.of(context).unfocus();
                            },
                            child: ListTile(
                              title: Text(
                                captalize(option),
                                maxLines: 2,
                                style:
                                TextStyle(color: widget.textSuggetionsColor),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}