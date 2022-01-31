import 'package:app_radiologia/telas/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaTermo extends StatefulWidget {
  const TelaTermo({Key key}) : super(key: key);

  @override
  _TelaTermoState createState() => _TelaTermoState();
}

class _TelaTermoState extends State<TelaTermo> {
  FirebaseFirestore termo = FirebaseFirestore.instance;
  String text = "";
  var dados;

  @override
  void initState() {
    super.initState();
    recuperarTermo();
  }

  saveValue() async {
    final aceiteSave = await SharedPreferences.getInstance();
    await aceiteSave.setBool("aceite", false);
  }

  recuperarTermo() async {
    DocumentSnapshot snapshot =
        await termo.collection("termo").doc('RdAtplqYZ3uQFcH7LBSQ').get();

    dados = snapshot.data();
    setState(() {
      text = dados["termo"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Text(
              "Termo",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(right: 20, left: 20, top: 20),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Text(text),
            )),
            Divider(
              color: Colors.blue,
              thickness: 0.8,
            ),
            TextButton(
                onPressed: () {
                  saveValue();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 65, right: 65),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: Text("Aceito",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                )),
          ],
        ),
      ),
    );
  }
}
