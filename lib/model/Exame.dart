class Exame{
  String id;
  String nome;
  String cod_sus;
  List parte_corpo;
  List descricao;
  List indicacao;
  List notas;
  List prioridades;
  Map sinais;
  Map sintomas;

  Exame({this.id, this.nome, this.cod_sus, this.parte_corpo, this.descricao, this.indicacao,
      this.notas, this.prioridades, this.sinais, this.sintomas});


  factory Exame.fromJson(Map<String,dynamic> map, String id){
    return Exame(
      id: id,
      nome: map['nome'],
      cod_sus: map['cod_sus'],
      parte_corpo: map['parte_corpo'],
      descricao: map['descricao'],
      indicacao: map['indicacao'],
      notas: map['notas'],
      prioridades: map['prioridades'],
      sinais: map["sinais"],
      sintomas: map['sintoma']

    );
  }


}