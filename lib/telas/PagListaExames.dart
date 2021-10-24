import 'package:app_radiologia/model/Exame.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PagExame.dart';

class PagListaExames extends StatefulWidget {
  final IconData icon;
  final String text;
  final Query exames;

  const PagListaExames({Key key, this.icon, this.text, this.exames}) : super(key: key);

  @override
  _PagListaExamesState createState() => _PagListaExamesState();
}

class _PagListaExamesState extends State<PagListaExames> {

  Widget itemLista(item){
    Exame e = Exame.fromJson(item.data(), item.id);
    return Padding(
      padding: EdgeInsets.only(left: 6, bottom: 20, top: 10),
      child: ListTile(
          title: Text(
            e.nome,
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PagExame(exame: e)));
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(
              widget.icon,
              size: 25,
            ),
            Text(
              "  ${widget.text}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: widget.exames.snapshots(),
          builder: (context, snapshot){
    switch (snapshot.connectionState){
      case ConnectionState.none:
        return Center(child: Text('Erro ao conectar no Firebase'));
      case ConnectionState.waiting:
        return Center(child: CircularProgressIndicator());
      default:
        final dados = snapshot.requireData;
        return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(20),
            child: ListView.separated(
            padding: EdgeInsets.only(right: 20,left: 20),
            itemCount: dados.size,
            separatorBuilder: (contex, index) => Divider(
            height: 3,
            color: Colors.blue,
            ),
            itemBuilder: (context, index){
              return itemLista(dados.docs[index]);
            }
            )
        );
    }
          }
      )
    );
  }
}
