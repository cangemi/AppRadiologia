import 'package:app_radiologia/model/Exame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PagExame extends StatefulWidget {
  final Exame exame;
  const PagExame({Key key, this.exame}) : super(key: key);

  @override
  _PagExameState createState() => _PagExameState();
}

class _PagExameState extends State<PagExame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.exame.nome),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Text(
                "Código do SUS: " + widget.exame.cod_sus,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: widget.exame.descricao == null
                  ? Text(
                      "Indicação:",
                      style: TextStyle(fontSize: 20),
                    )
                  : Text(
                      "Descrição:",
                      style: TextStyle(fontSize: 20),
                    ),
            ),
            widget.exame.descricao == null
                ? Expanded(
                    child: ListView.builder(
                    itemCount: widget.exame.indicacao.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(widget.exame.indicacao[index]),
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                    itemCount: widget.exame.descricao.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(widget.exame.descricao[index]),
                    ),
                  )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.exame.prioridades == null
                    ? Container()
                    : buildContainer("Prioridades", widget.exame.prioridades),
                widget.exame.notas == null
                    ? Container()
                    : buildContainer("Notas", widget.exame.notas),
                widget.exame.indicacao == null
                    ? Container()
                    : buildContainer("Indicação", widget.exame.indicacao)
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildContainer(String text, List list) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextButton(
          onPressed: () {
            telaContainer(text, list);
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
        ));
  }

  telaContainer(text, list) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: ListView.separated(
                  separatorBuilder: (contex, index) => Divider(
                    height: 3,
                    color: Colors.white,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index],
                          style: TextStyle(color: Colors.white)),
                    );
                  }),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Fechar",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            );
        });
  }
}
