import 'package:flutter_bloc/flutter_bloc.dart';
import 'model.dart';
import 'repository.dart';
import 'service.dart';

abstract class ProdutoState {}

abstract class ProdutoLoadState extends ProdutoState {}

class ProdutoLoadInitial extends ProdutoLoadState {}

class ProdutoLoading extends ProdutoLoadState {}

class ProdutoLoaded extends ProdutoLoadState {
  final List<Produto> produtos;
  ProdutoLoaded(this.produtos);
}

class ProdutoLoadError extends ProdutoLoadState {
  String message;
  ProdutoLoadError(this.message);
}

abstract class ProdutoDeleteState extends ProdutoState {}

class ProdutoDeleteInitial extends ProdutoDeleteState {}

class ProdutoDeleting extends ProdutoDeleteState {}

class ProdutoDeleted extends ProdutoDeleteState {
  final Produto produto;
  ProdutoDeleted(this.produto);
}

class ProdutoDeleteError extends ProdutoDeleteState {
  String message;
  ProdutoDeleteError(this.message);
}

abstract class ProdutoUpdateState extends ProdutoState {}

class ProdutoUpdateInitial extends ProdutoUpdateState {}

class ProdutoUpdating extends ProdutoUpdateState {}

class ProdutoUpdated extends ProdutoUpdateState {
  final Produto produto;
  ProdutoUpdated(this.produto);
}

class ProdutoUpdateError extends ProdutoUpdateState {
  String message;
  ProdutoUpdateError(this.message);
}

abstract class ProdutoCreateState extends ProdutoState {}

class ProdutoCreateInitial extends ProdutoCreateState {}

class ProdutoCreating extends ProdutoCreateState {}

class ProdutoCreated extends ProdutoCreateState {
  final Produto produto;
  ProdutoCreated(this.produto);
}

class ProdutoCreateError extends ProdutoCreateState {
  String message;
  ProdutoCreateError(this.message);
}

abstract class ProdutoEvent {}

class LoadProdutos extends ProdutoEvent {}

class DeleteProduto extends ProdutoEvent {
  final Produto produto;
  DeleteProduto(this.produto);
}

class UpdateProduto extends ProdutoEvent {
  final Produto produto;
  UpdateProduto(this.produto);
}

class CreateProduto extends ProdutoEvent {
  final Produto produto;
  CreateProduto(this.produto);
}

class LoadProdutoBloc extends Bloc<ProdutoEvent, ProdutoLoadState> {
  final ProdutoService _service;
  LoadProdutoBloc(this._service) : super(ProdutoLoadInitial()) {
    on<LoadProdutos>(
      (event, emit) async {
        emit(ProdutoLoading());
        try {
          final produtos = await _service.listAll();
          emit(ProdutoLoaded(produtos));
        } catch (e) {
          emit(ProdutoLoadError(e.toString()));
        }
      },
    );
  }
}

class DeleteProdutoBloc extends Bloc<ProdutoEvent, ProdutoDeleteState> {
  final ProdutoService _produtoRepository;
  DeleteProdutoBloc(this._produtoRepository) : super(ProdutoDeleteInitial()) {
    on<DeleteProduto>(
      (event, emit) async {
        emit(ProdutoDeleting());
        try {
          final produto = await _produtoRepository.delete(event.produto);
          emit(ProdutoDeleted(produto));
        } catch (e) {
          emit(ProdutoDeleteError(e.toString()));
        }
      },
    );
  }
}

class UpdateProdutoBloc extends Bloc<ProdutoEvent, ProdutoUpdateState> {
  final ProdutoRepository _produtoRepository;
  UpdateProdutoBloc(this._produtoRepository) : super(ProdutoUpdateInitial()) {
    on<UpdateProduto>(
      (event, emit) async {
        emit(ProdutoUpdating());
        try {
          final produto = await _produtoRepository.update(event.produto);
          emit(ProdutoUpdated(produto));
        } catch (e) {
          emit(ProdutoUpdateError(e.toString()));
        }
      },
    );
  }
}

class CreateProdutoBloc extends Bloc<ProdutoEvent, ProdutoCreateState> {
  final ProdutoService _produtoService;
  CreateProdutoBloc(this._produtoService) : super(ProdutoCreateInitial()) {
    on<CreateProduto>(
      (event, emit) async {
        emit(ProdutoCreating());
        try {
          final produto = await _produtoService.create(event.produto);
          emit(ProdutoCreated(produto));
        } catch (e) {
          emit(ProdutoCreateError(e.toString()));
        }
      },
    );
  }
}
