import 'package:app_radiologia/model/Exame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final Query<Object> query;
  final String text;
  final Function onTap;
  final Function title;
  final double height;
  final double width;

  const CustomAlertDialog(
      {Key key,
      @required this.text,
      @required this.query,
      this.onTap,
        this.title,
      this.height,
      this.width})
      : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  Widget itemLista(item) {
    Exame e = Exame.fromJson(item.data(), item.id);
    String title = widget.title(e);
    return ListTile(
      title: Text(title,style: TextStyle(color: Colors.white)),
      onTap: () => widget.onTap(e),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.query.snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: Text('Erro ao conectar no Firebase'));
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            final dados = snapshot.requireData;
            return AlertDialog(
              backgroundColor: Colors.blue,
              title: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              content: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: widget.height,
                width: widget.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dados.size,
                  itemBuilder: (context, index) {
                    return itemLista(dados.docs[index]);
                  },
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Fechar",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
        }
      },
    );
  }
}
