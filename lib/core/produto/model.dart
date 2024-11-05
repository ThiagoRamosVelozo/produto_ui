import 'package:produto_ui/tools/string_to_datetime.dart';

class Produto {
  final int? id;
  final String descricao;
  final DateTime data;
  final double preco;
  final int estoque;

  Produto({
    this.id,
    required this.descricao,
    required this.preco,
    required this.estoque,
    required this.data,
  });

  factory Produto.fromMap(Map<String, dynamic> json) => Produto(
        id: json['id'],
        descricao: json['descricao'],
        preco: (json['preco'] is int)
            ? (json['preco'] as int).toDouble()
            : json['preco'],
        data: stringToDateTime(json['data_']),
        estoque: json['estoque'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'data_': '${data.year}-${data.month}-${data.day}',
        'descricao': descricao,
        'preco': preco,
        'estoque': estoque,
      };
}
