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
  List _list = [];
  List<Exame> exList = [];

  void _carregarExames() {
    for (int i = 0; i <= 29; i++) {
      Map<String, dynamic> exames = Map();
      exames["titulo"] = "Exame ${i + 1}";
      _list.add(exames);
    }
  }
   void _carregar()async{
     QuerySnapshot querySnapshot = await widget.exames.get();
     for (DocumentSnapshot ex in querySnapshot.docs) {
       setState(() {
         exList.add(Exame.fromJson(ex.data(), ex.id));
       });
     }
   }

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    _carregarExames();

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
      body: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(20),
        child: ListView.separated(
            padding: EdgeInsets.only(right: 20,left: 20),
            itemCount: _list.length,//exList.length,
            separatorBuilder: (contex, index) => Divider(
              height: 3,
              color: Colors.blue,
            ),
            itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 6, bottom: 20, top: 10),
                child: ListTile(
                    title: Text(
                      _list[index]["titulo"],//exList[index].nome,
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PagExame()));
                    }))),
      )
    );
  }
}
