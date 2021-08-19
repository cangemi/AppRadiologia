import 'dart:ui';

import 'package:app_radiologia/FirestoreConn.dart';
import 'package:app_radiologia/model/Exame.dart';
import 'package:app_radiologia/widgets/CustomAlertDialog.dart';
import 'package:app_radiologia/widgets/CustomDropdown.dart';
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
  String _primeiroSintoma;
  String _segundoSintoma;
  String _primeiroSinal;
  String _segundoSinal;
  String _hintSintoma = "Escolha um sintoma";
  String _hintSinal = "Escolha um sinal      ";
  Query exameList;
  CollectionReference exames;
  CollectionReference sinais;
  List<Exame> exList = [];

  List _listaSintomaPrincipal = ["Escolha um sintoma"];
  List _listaSintomaSecundario = ["Escolha um sintoma"];
  List _listaSinais = ["Escolha um sinal      "];

  FirestoreConn firestoreConn = FirestoreConn();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void _busca() {
    exList = [];
    exameList = null;
    if (_primeiroSintoma != _hintSintoma &&
        _segundoSintoma != _hintSintoma &&
        _primeiroSinal != _hintSinal &&
        _segundoSinal != _hintSinal) {
      exameList = exames
          .where("sintoma.$_primeiroSintoma", isEqualTo: true)
          .where("sintoma.$_segundoSintoma", isEqualTo: true)
          .where("sinais.$_primeiroSinal", isEqualTo: true)
          .where("sinais.$_segundoSinal", isEqualTo: true);
    } else {
      if (_primeiroSintoma != _hintSintoma &&
          _segundoSintoma != _hintSintoma &&
          _primeiroSinal != _hintSinal) {
        exameList = exames
            .where("sintoma.$_primeiroSintoma", isEqualTo: true)
            .where("sintoma.$_segundoSintoma", isEqualTo: true)
            .where("sinais.$_primeiroSinal", isEqualTo: true);
      } else {
        if (_primeiroSintoma != _hintSintoma &&
            _segundoSintoma != _hintSintoma &&
            _segundoSinal != _hintSinal) {
          exameList = exames
              .where("sintoma.$_primeiroSintoma", isEqualTo: true)
              .where("sintoma.$_segundoSintoma", isEqualTo: true)
              .where("sinais.$_segundoSinal", isEqualTo: true);
        } else {
          if (_primeiroSintoma != _hintSintoma &&
              _segundoSintoma != _hintSintoma) {
            exameList = exames
                .where("sintoma.$_primeiroSintoma", isEqualTo: true)
                .where("sintoma.$_segundoSintoma", isEqualTo: true);
          } else {
            if (_primeiroSintoma != _hintSintoma &&
                _primeiroSinal != _hintSinal) {
              exameList = exames
                  .where("sintoma.$_primeiroSintoma", isEqualTo: true)
                  .where("sinais.$_primeiroSinal", isEqualTo: true);
            } else {
              if (_primeiroSintoma != _hintSintoma &&
                  _segundoSinal != _hintSinal) {
                print("entrou here");
                print(_primeiroSintoma);
                print(_segundoSinal);
                exameList = exames
                    .where("sintoma.$_primeiroSintoma", isEqualTo: true)
                    .where("sinais.$_segundoSinal", isEqualTo: true);
              } else {
                if (_segundoSintoma != _hintSintoma &&
                    _primeiroSinal != _hintSinal) {
                  exameList = exames
                      .where("sintoma.$_segundoSintoma", isEqualTo: true)
                      .where("sinais.$_primeiroSinal", isEqualTo: true);
                } else {
                  if (_segundoSintoma != _hintSintoma &&
                      _segundoSinal != _hintSinal) {
                    exameList = exames
                        .where("sintoma.$_segundoSintoma", isEqualTo: true)
                        .where("sinais.$_segundoSinal", isEqualTo: true);
                  } else {
                    if (_primeiroSintoma != _hintSintoma) {
                      exameList = exames.where("sintoma.$_primeiroSintoma",
                          isEqualTo: true);
                    } else {
                      if (_segundoSintoma != _hintSintoma) {
                        exameList = exames.where("sintoma.$_segundoSintoma",
                            isEqualTo: true);
                      } else {
                        print("não entrou em nenhum");
                        exameList = null;
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
    _busca();
    querySnapshot = await exameList.get();
    for (DocumentSnapshot ex in querySnapshot.docs) {
      exList.add(Exame.fromJson(ex.data(), ex.id));
    }
    if (querySnapshot.size > 1) {
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PagExame(exame: exList[0])));
    }
  }

//-------------------------------------------------------------------------------
  List<String> listaSinal = [];

  @override
  void initState() {
    super.initState();
    //  --------------------
    exames = FirebaseFirestore.instance.collection("exames");
    sinais = FirebaseFirestore.instance.collection("sinais");

    //  ----------------
    firestoreConn.lista((DocumentSnapshot s) {
      setState(() {
        if (!_listaSintomaPrincipal.contains(s["sintoma"])) {
          _listaSintomaPrincipal.add(s["sintoma"]);
        }
      });
    }, "sintomaPrincipal");
    firestoreConn.lista((DocumentSnapshot s) {
      setState(() {
        if (!_listaSintomaSecundario.contains(s["sintoma"])) {
          _listaSintomaSecundario.add(s["sintoma"]);
        }
      });
    }, "sintomaSecundario");
    firestoreConn.lista((DocumentSnapshot s) {
      setState(() {
        if (!_listaSinais.contains(s["sinal"])) {
          _listaSinais.add(s["sinal"]);
          listaSinal.add(s["sinal"]);
        }
      });
    }, "sinais");
    _primeiroSintoma = _listaSintomaPrincipal[0];
    _segundoSintoma = _listaSintomaSecundario[0];
    _primeiroSinal = _listaSinais[0];
    _segundoSinal = _listaSinais[0];
  }

  //------------------------------------------------------------------------
  TextEditingController textEditingController = TextEditingController();
  Query listTeste;
  List<String> listaSinal2 = [];

  funcao() async {
    QuerySnapshot qS = await listTeste.get();
    for (DocumentSnapshot ex in qS.docs) {
      var dado = ex;
      setState(() {
        print(dado["sinal"]);
        if (!listaSinal2.contains(dado["sinal"])) {
          listaSinal2.add(dado["sinal"]);
        }
      });
    }
  }

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
          CustomDropdown(
              value: _primeiroSintoma,
              textHint: "escolha um sintoma",
              onChanged: (newValue) {
                setState(() {
                  _primeiroSintoma = newValue;
                });
              },
              list: _listaSintomaPrincipal),
          CustomDropdown(
              value: _segundoSintoma,
              textHint: "escolha um sintoma",
              onChanged: (newValue) {
                setState(() {
                  _segundoSintoma = newValue;
                });
              },
              list: _listaSintomaSecundario),
          CustomDropdown(
              value: _primeiroSinal,
              textHint: "escolha um sintoma",
              onChanged: (newValue) {
                setState(() {
                  _primeiroSinal = newValue;
                });
              },
              list: _listaSinais),
          // CustomDropdown(
          //     value: _segundoSinal,
          //     textHint: "escolha um sintoma",
          //     onChanged: (newValue) {
          //       setState(() {
          //         _segundoSinal = newValue;
          //       });
          //     },
          //     list: _listaSinais),
          TextFieldSuggestions(
            controller: textEditingController,
            list: listaSinal2,
            labelText: 'Segundo sinal',
            textSuggetionsColor: Colors.white,
            outlineInputBorderColor: Colors.blue,
            suggetionsBackgroundColor: Colors.blue,
            returnedValue: (String value)=> _segundoSinal = value,
            onChange: (String value) {
              if (value == "") {
                setState(() {
                  listaSinal2 = [];
                });
              } else {
                setState(() {
                  listaSinal2 = [];
                });
                String capitalize =
                    value[0].toUpperCase() + value.substring(1).toLowerCase();
                listTeste = sinais
                    .where("sinal", isGreaterThanOrEqualTo: capitalize)
                    .where("sinal", isLessThanOrEqualTo: capitalize + "\uf8ff");
                funcao();
              }
            },
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
