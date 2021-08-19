import 'package:app_radiologia/telas/PagListaExames.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TelaExames extends StatefulWidget {
  @override
  _TelaExamesState createState() => _TelaExamesState();
}

class _TelaExamesState extends State<TelaExames> {
  CollectionReference exames;
  Query exameList;

   void _nextPag(IconData icon,String text, Query exameList ){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>
            PagListaExames(icon: icon,text: text, exames: exameList))
    );
  }
  @override
  void initState() {
    super.initState();
    exames = FirebaseFirestore.instance.collection("exames");
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: MediaQuery.of(context).size.aspectRatio * 1.9,
      children: <Widget>[
        customBuildGestureDetector(Icons.ac_unit,"Sistema Reprodutor Feminino"),
        customBuildGestureDetector(Icons.height,"Sistema Reprodutor Feminino"),
        customBuildGestureDetector(Icons.cabin,"Parte do corpo"),
        customBuildGestureDetector(Icons.list,"Parte do corpo"),
        customBuildGestureDetector(Icons.access_alarm_sharp,"Parte do corpo"),
        customBuildGestureDetector(Icons.accessibility_new,"Parte do corpo"),
      ],
    );
  }

  GestureDetector customBuildGestureDetector(IconData icon, String text) {
    return GestureDetector(
        onTap: (){
          exameList = exames.where("parte_corpo",isEqualTo: text);
          _nextPag(icon,text,exameList);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 50,
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ),
      );
  }
}
