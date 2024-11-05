import '../dio.dart';

import 'model.dart';

class ProdutoRepository {
  final url = "produtos";
  Future<List<Produto>> fetchAll() async {
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return response.data.map<Produto>((map) => Produto.fromMap(map)).toList();
    }
    throw Exception('Não foi possível obter os produtos');
  }

  Future<Produto> delete(Produto produto) async {
    final response = await dio.delete('$url/${produto.id}');
    if (response.statusCode == 200) {
      return Produto.fromMap(response.data);
    }
    throw Exception('Não foi possível remover o produto');
  }

  Future<Produto> update(Produto produto) async {
    final response = await dio.put('$url/${produto.id}', data: produto.toMap());
    if (response.statusCode == 200) {
      return Produto.fromMap(response.data);
    }
    throw Exception('Não foi possível atualizar o produto');
  }

  Future<Produto> create(Produto produto) async {
    final response = await dio.post(url, data: produto.toMap());
    if (response.statusCode == 201) {
      return Produto.fromMap(response.data);
    }
    throw Exception('Não foi possível adicionar o produto');
  }
}
