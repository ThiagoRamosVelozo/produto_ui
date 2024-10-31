import 'model.dart';
import 'repository.dart';

class ProdutoService {
  final ProdutoRepository _repository;

  ProdutoService(this._repository);

  Future<List<Produto>> listAll() async => _repository.fetchAll();
  Future<Produto> create(Produto produto) async => _repository.create(produto);
  Future<Produto> delete(Produto produto) async => _repository.delete(produto);
  Future<Produto> update(Produto produto) async => _repository.update(produto);
}
