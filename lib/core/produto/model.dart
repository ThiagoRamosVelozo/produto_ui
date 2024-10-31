class Produto {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;
  final int estoque;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.estoque,
  });

  factory Produto.fromMap(Map<String, dynamic> json) => Produto(
        id: json['id'],
        nome: json['nome'],
        descricao: json['descricao'],
        preco: (json['preco'] is int)
            ? (json['preco'] as int).toDouble()
            : json['preco'],
        estoque: json['estoque'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'estoque': estoque,
      };
}
