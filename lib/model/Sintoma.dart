class Sintoma{
  String id;
  String nome;


  Sintoma({this.id, this.nome});


  factory Sintoma.fromJson(Map<String,dynamic> map, String id){
    return Sintoma(
        id: id,
        nome: map['nome']
    );
  }


}