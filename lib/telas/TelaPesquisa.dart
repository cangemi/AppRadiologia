
import 'package:app_radiologia/model/Exame.dart';
import 'package:app_radiologia/widgets/CustomAlertDialog.dart';
import 'package:app_radiologia/widgets/TextFieldSuggestions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'PagExame.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key key}) : super(key: key);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  QuerySnapshot querySnapshot;
  List<String> symptoms = [];
  String _hintSintoma = "Escolha um sintoma";
  CollectionReference sintomas;


  CollectionReference primeiroSintomas;
  String _primeiroSintoma = "";


  CollectionReference segundoSintomas;
  String _segundoSintoma = "";



  CollectionReference sinais;
  String _sinal = "";
  String _hintSinal = "Escolha um sinal";
  List<String> signal = [];

  CollectionReference diagnosticos;
  String _hipoteseDiagnostica = "";
  String _hintDiagnostico = "Hipotese Diagnostica";
  List<String> diagnosis= [];

  Query exameList;
  CollectionReference exames;
  Query listTeste;
  List<Exame> exList = [];


  message(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      shape: Border(top: BorderSide(color: Colors.blue, width: 3)),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _busca() {
    exList = [];
    exameList = null;
    if(_primeiroSintoma.isNotEmpty&&_segundoSintoma.isNotEmpty
        &&_sinal.isNotEmpty&&_hipoteseDiagnostica.isNotEmpty){
      print("primeira Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("sinais.$_sinal", isEqualTo: true)
          .where("diagnostico.$_hipoteseDiagnostica", isEqualTo: true);
    }else if(_primeiroSintoma.isNotEmpty&&_segundoSintoma.isNotEmpty
        &&_sinal.isNotEmpty){
      print("segunda Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("sinais.$_sinal", isEqualTo: true);

    }else if(_primeiroSintoma.isNotEmpty&&_segundoSintoma.isNotEmpty
        &&_hipoteseDiagnostica.isNotEmpty){
      print("terceira Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("diagnostico.$_hipoteseDiagnostica", isEqualTo: true);
    }else if(_primeiroSintoma.isNotEmpty&&_segundoSintoma.isNotEmpty){
      print("quarta Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sintoma.$_segundoSintoma", isEqualTo: true);
    }else if(_primeiroSintoma.isNotEmpty&&_sinal.isNotEmpty){
      print("quinta Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sinais.$_sinal", isEqualTo: true);
    }else if(_primeiroSintoma.isNotEmpty&&_hipoteseDiagnostica.isNotEmpty){
      print("sexta Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("diagnostico.$_hipoteseDiagnostica",
          isEqualTo: true);
    }else if(_segundoSintoma.isNotEmpty&&_sinal.isNotEmpty){
      print("setima Pesquisa");
      exameList = exames
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("sinais.$_sinal", isEqualTo: true);
    }else if(_segundoSintoma.isNotEmpty&&_hipoteseDiagnostica.isNotEmpty){
      print("oitava Pesquisa");
      exameList = exames
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("diagnostico.$_hipoteseDiagnostica",
          isEqualTo: true);
    }else if(_sinal.isNotEmpty&&_hipoteseDiagnostica.isNotEmpty){
      exameList = exames
          .where("sinais.$_sinal", isEqualTo: true)
          .where("diagnostico.$_hipoteseDiagnostica",
          isEqualTo: true);
    }else if(_primeiroSintoma.isNotEmpty){
      print("nona Pesquisa");
      exameList = exames.where("sintoma.$_primeiroSintoma",
          isEqualTo: true);
    }else if(_segundoSintoma.isNotEmpty){
      print("decima Pesquisa");
      exameList = exames.where("sintoma.$_segundoSintoma",
          isEqualTo: true);
    }else if(_sinal.isNotEmpty){
      print("decima primeira Pesquisa");
      exameList =
          exames.where("sinais.$_sinal", isEqualTo: true);
    }else if(_hipoteseDiagnostica.isNotEmpty){
      print("decima segunda Pesquisa");
      exameList = exames.where(
          "diagnostico.$_hipoteseDiagnostica",
          isEqualTo: true);
    }
  }

  void _pesquisa() async {
    if (_primeiroSintoma == "" &&
        _segundoSintoma == "" &&
        _sinal == "" &&
        _hipoteseDiagnostica == "") {
      message("Preencha um dos campos para pesquisar");
    } else {
      _busca();
      try {
        querySnapshot = await exameList.get();
        for (DocumentSnapshot ex in querySnapshot.docs) {
          exList.add(Exame.fromJson(ex.data(), ex.id));
        }
        if(exList[0].nome.isNotEmpty){
          if (exList.length > 1) {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                      text: "Possiveis exames",
                      query: exameList,
                      title: (Exame e) {
                        return e.nome;
                      },
                      onTap: (Exame e) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PagExame(exame: e)))
                            .then((value) => Navigator.pop(this.context));
                      });
                });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PagExame(exame: exList[0])));
          }
        }else{
          message("Nenhum exame encontado");
        }
      } catch (_){
        message("Nenhum exame encontado");
      }
    }
  }

  makeList(Function f, CollectionReference collectionReference) async {
    QuerySnapshot qS = await collectionReference.get();
    for (DocumentSnapshot ex in qS.docs) {
      var dado = ex;
      f(dado);
    }

  }


//-------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    //  --------------------
    exames = FirebaseFirestore.instance.collection("exames");
    sinais = FirebaseFirestore.instance.collection("sinais");
    sintomas = FirebaseFirestore.instance.collection("sintomas");
    diagnosticos = FirebaseFirestore.instance.collection("hipoteseDiagnostica");

    makeList((dado){
      setState(() {
        symptoms.add(dado["sintoma"]);
      });
    },sintomas);
    makeList((dado){
      setState(() {
        signal.add(dado["sinal"]);
      });
    },sinais);
    makeList((dado){
      setState(() {
        diagnosis.add(dado["diagnostico"]);
      });
    },diagnosticos);
    //  ----------------
  }


  //------------------------------------------------------------------------

  //-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: Text(
              "Escolha os sintomas e sinais",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TextFieldSuggestions(
            list: symptoms,
            labelText: _hintSintoma,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _primeiroSintoma = value,

          ),
          SizedBox(
            height: 20,
          ),
          TextFieldSuggestions(
            list: symptoms,
            labelText: _hintSintoma,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _segundoSintoma = value,
          ),
          SizedBox(
            height: 20,
          ),
          TextFieldSuggestions(
            list: signal,
            labelText: _hintSinal,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _sinal = value,
          ),
          SizedBox(
            height: 20,
          ),
          TextFieldSuggestions(
            list: diagnosis,
            labelText: _hintDiagnostico,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _hipoteseDiagnostica = value,
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                _pesquisa();
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 65, right: 65),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: Text("Pesquisar",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ))
        ],
      )),
    );
  }
}
