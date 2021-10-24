import 'dart:ui';

//import 'package:app_radiologia/FirestoreConn.dart';
import 'package:app_radiologia/model/Exame.dart';
import 'package:app_radiologia/widgets/CustomAlertDialog.dart';
import 'package:app_radiologia/widgets/TextFieldSuggestions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PagExame.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key key}) : super(key: key);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  QuerySnapshot querySnapshot;
  String _hintSintoma = "Escolha um sintoma";

  CollectionReference sintomas;

  TextEditingController _primeiroSintomaController = TextEditingController();
  CollectionReference primeiroSintomas;
  String _primeiroSintoma = "";
  List<String> _listaSintomaPrincipal = [];

  TextEditingController _segundoSintomaController = TextEditingController();
  CollectionReference segundoSintomas;
  String _segundoSintoma = "";
  List<String> _listaSintomaSecundario = [];

  TextEditingController _sinalController = TextEditingController();
  CollectionReference sinais;
  String _sinal = "";
  List<String> _listaSinais = [];
  String _hintSinal = "Escolha um sinal";

  TextEditingController _diagnosticoController = TextEditingController();
  CollectionReference diagnosticos;
  String _hipoteseDiagnostica = "";
  List<String> _listaDiagnosticos = [];
  String _hintDiagnostico = "Hipotese Diagnostica";

  Query exameList;
  CollectionReference exames;
  Query listTeste;
  List<Exame> exList = [];

  //FirestoreConn firestoreConn = FirestoreConn();
  //FirebaseFirestore db = FirebaseFirestore.instance;

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

    try {
      print("primeira Pesquisa");
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("sinais.$_sinal", isEqualTo: true)
          .where("diagnostico.$_hipoteseDiagnostica", isEqualTo: true);
    } catch (_) {
      try {
        print("segunda Pesquisa");
        exameList = exames
            .where("sintoma.$_primeiroSintoma", isEqualTo: true)
            .where("sintoma.$_segundoSintoma", isEqualTo: true)
            .where("sinais.$_sinal", isEqualTo: true);
      } catch (_) {
        try {
          print("terceira Pesquisa");
          exameList = exames
              .where("sintoma.$_primeiroSintoma", isEqualTo: true)
              .where("sintoma.$_segundoSintoma", isEqualTo: true)
              .where("diagnostico.$_hipoteseDiagnostica", isEqualTo: true);
        } catch (_) {
          try {
            print("quarta Pesquisa");
            exameList = exames
                .where("sintoma.$_primeiroSintoma", isEqualTo: true)
                .where("sintoma.$_segundoSintoma", isEqualTo: true);
          } catch (_) {
            try {
              print("quinta Pesquisa");
              exameList = exames
                  .where("sintoma.$_primeiroSintoma", isEqualTo: true)
                  .where("sinais.$_sinal", isEqualTo: true);
            } catch (_) {
              try {
                print("sexta Pesquisa");
                exameList = exames
                    .where("sintoma.$_primeiroSintoma", isEqualTo: true)
                    .where("diagnostico.$_hipoteseDiagnostica",
                        isEqualTo: true);
              } catch (_) {
                try {
                  print("setima Pesquisa");
                  exameList = exames
                      .where("sintoma.$_segundoSintoma", isEqualTo: true)
                      .where("sinais.$_sinal", isEqualTo: true);
                } catch (_) {
                  try {
                    print("oitava Pesquisa");
                    exameList = exames
                        .where("sintoma.$_segundoSintoma", isEqualTo: true)
                        .where("diagnostico.$_hipoteseDiagnostica",
                            isEqualTo: true);
                  } catch (_) {
                    try {
                      exameList = exames
                          .where("sinais.$_sinal", isEqualTo: true)
                          .where("diagnostico.$_hipoteseDiagnostica",
                              isEqualTo: true);
                    } catch (_) {
                      try {
                        print("nona Pesquisa");
                        exameList = exames.where("sintoma.$_primeiroSintoma",
                            isEqualTo: true);
                      } catch (_) {
                        try {
                          print("decima Pesquisa");
                          exameList = exames.where("sintoma.$_segundoSintoma",
                              isEqualTo: true);
                        } catch (_) {
                          try {
                            print("decima primeira Pesquisa");
                            exameList =
                                exames.where("sinais.$_sinal", isEqualTo: true);
                          } catch (_) {
                            try {
                              print("decima segunda Pesquisa");
                              exameList = exames.where(
                                  "diagnostico.$_hipoteseDiagnostica",
                                  isEqualTo: true);
                            } catch (_) {}
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
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

  funcao(Function f) async {
    QuerySnapshot qS = await listTeste.get();
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
    primeiroSintomas =
        FirebaseFirestore.instance.collection("sintomaPrincipal");
    segundoSintomas =
        FirebaseFirestore.instance.collection("sintomaSecundario");

    //  ----------------
  }

  @override
  void dispose() {
    super.dispose();
    _primeiroSintomaController.dispose();
    _segundoSintomaController.dispose();
    _sinalController.dispose();
    _diagnosticoController.dispose();
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
            controller: _primeiroSintomaController,
            list: _listaSintomaPrincipal,
            labelText: _hintSintoma,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _primeiroSintoma = value,
            onChange: (String value) {
              if (value == "") {
                setState(() {
                  _listaSintomaPrincipal = [];
                  _primeiroSintoma = "";
                });
              } else {
                setState(() {
                  _listaSintomaPrincipal = [];
                });
                String texto = value.toLowerCase();
                listTeste = sintomas
                    .where("sintoma", isGreaterThanOrEqualTo: texto)
                    .where("sintoma", isLessThanOrEqualTo: texto + "\uf8ff");

                funcao((DocumentSnapshot dado) {
                  setState(() {
                    print(dado["sintoma"]);
                    if (!_listaSintomaPrincipal.contains(dado["sintoma"])) {
                      _listaSintomaPrincipal.add(dado["sintoma"]);
                    }
                  });
                });
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFieldSuggestions(
            controller: _segundoSintomaController,
            list: _listaSintomaSecundario,
            labelText: _hintSintoma,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _segundoSintoma = value,
            onChange: (String value) {
              if (value == "") {
                setState(() {
                  _listaSintomaSecundario = [];
                  _segundoSintoma = "";
                });
              } else {
                setState(() {
                  _listaSintomaSecundario = [];
                });
                String texto = value.toLowerCase();
                listTeste = sintomas
                    .where("sintoma", isGreaterThanOrEqualTo: texto)
                    .where("sintoma", isLessThanOrEqualTo: texto + "\uf8ff");
                funcao((DocumentSnapshot dado) {
                  setState(() {
                    print(dado["sintoma"]);
                    if (!_listaSintomaSecundario.contains(dado["sintoma"])) {
                      _listaSintomaSecundario.add(dado["sintoma"]);
                    }
                  });
                });
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFieldSuggestions(
            controller: _sinalController,
            list: _listaSinais,
            labelText: _hintSinal,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _sinal = value,
            onChange: (String value) {
              if (value == "") {
                setState(() {
                  _listaSinais = [];
                  _sinal = "";
                });
              } else {
                setState(() {
                  _listaSinais = [];
                });
                String texto = value.toLowerCase();
                listTeste = sinais
                    .where("sinal", isGreaterThanOrEqualTo: texto)
                    .where("sinal", isLessThanOrEqualTo: texto + "\uf8ff");
                funcao((DocumentSnapshot dado) {
                  setState(() {
                    print(dado["sinal"]);
                    if (!_listaSinais.contains(dado["sinal"])) {
                      _listaSinais.add(dado["sinal"]);
                    }
                  });
                });
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFieldSuggestions(
            controller: _diagnosticoController,
            list: _listaDiagnosticos,
            labelText: _hintDiagnostico,
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value) => _hipoteseDiagnostica = value,
            onChange: (String value) {
              if (value == "") {
                setState(() {
                  _listaDiagnosticos = [];
                  _hipoteseDiagnostica = "";
                });
              } else {
                setState(() {
                  _listaDiagnosticos = [];
                });
                String texto = value.toLowerCase();
                listTeste = diagnosticos
                    .where("diagnostico", isGreaterThanOrEqualTo: texto)
                    .where("diagnostico",
                        isLessThanOrEqualTo: texto + "\uf8ff");
                funcao((DocumentSnapshot dado) {
                  setState(() {
                    print(dado["diagnostico"]);
                    if (!_listaDiagnosticos.contains(dado["diagnostico"])) {
                      _listaDiagnosticos.add(dado["diagnostico"]);
                    }
                  });
                });
              }
            },
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
