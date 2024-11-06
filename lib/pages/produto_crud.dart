import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:produto_ui/core/produto/model.dart';
import 'package:produto_ui/tools/formatar_inteiro_casas.dart';
import 'package:produto_ui/tools/ptbr_string_to_datetime.dart';
import '../core/produto/bloc.dart';
import '../core/produto/repository.dart';
import '../core/produto/service.dart';
import '../defaults/buttons.dart';
import '../defaults/gradients.dart';

class ProdutoCrud extends StatefulWidget {
  const ProdutoCrud({super.key});

  @override
  State<ProdutoCrud> createState() => _ProdutoCrud();
}

class _ProdutoCrud extends State<ProdutoCrud> {
  final _service = ProdutoService(ProdutoRepository());
  final _pageController = PageController();
  final _descricaoController = TextEditingController();
  final _precoController = MoneyMaskedTextController(
      leftSymbol: 'R\$ ', decimalSeparator: ',', thousandSeparator: '.');
  final _estoqueController = TextEditingController();
  final _dataController = MaskedTextController(mask: '00/00/0000');
  final _insertFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  Produto? _produtoSelecionado;

  String appBarTitle = 'Produtos';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appBarTitle,
            style: const TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: gradient0,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(128, 0, 0, 0),
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  LoadProdutoBloc(_service)..add(LoadProdutos()),
            ),
            BlocProvider(create: (context) => CreateProdutoBloc(_service)),
            BlocProvider(create: (context) => UpdateProdutoBloc(_service)),
            BlocProvider(create: (context) => DeleteProdutoBloc(_service)),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<CreateProdutoBloc, ProdutoCreateState>(
                listener: (context, state) async {
                  if (state is ProdutoCreated) {
                    await _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    if (context.mounted) {
                      context.read<LoadProdutoBloc>().add(LoadProdutos());
                    }
                    setState(() {
                      appBarTitle = 'Produtos';
                    });
                  }
                },
              ),
              BlocListener<UpdateProdutoBloc, ProdutoUpdateState>(
                listener: (context, state) async {
                  if (state is ProdutoUpdated) {
                    _produtoSelecionado = null;
                    await _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    if (context.mounted) {
                      context.read<LoadProdutoBloc>().add(LoadProdutos());
                    }
                    setState(() {
                      appBarTitle = 'Produtos';
                    });
                  }
                },
              ),
              BlocListener<DeleteProdutoBloc, ProdutoDeleteState>(
                listener: (context, state) async {
                  if (state is ProdutoDeleted) {
                    _produtoSelecionado = null;
                    await _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    if (context.mounted) {
                      context.read<LoadProdutoBloc>().add(LoadProdutos());
                    }
                    setState(() {
                      appBarTitle = 'Produtos';
                    });
                  }
                },
              ),
            ],
            child: PageView(
              controller: _pageController,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<LoadProdutoBloc, ProdutoState>(
                          builder: (context, state) {
                            if (state is ProdutoLoaded) {
                              return ListView(
                                children: [
                                  const SizedBox(height: 16.0),
                                  ...state.produtos.map(
                                    (produto) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: GradientButton(
                                        onPressed: () async {
                                          _descricaoController.text =
                                              produto.descricao;
                                          _estoqueController.text =
                                              produto.estoque.toString();
                                          _precoController.text =
                                              produto.preco.toString();
                                          _dataController.text =
                                              '${formatarInteiroCasas(produto.data.day, 2)}/${formatarInteiroCasas(produto.data.month, 2)}/${produto.data.year}';
                                          setState(() {
                                            _produtoSelecionado = produto;
                                          });
                                          await _pageController.animateToPage(
                                            1,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            curve: Curves.easeInOut,
                                          );
                                          setState(() {
                                            appBarTitle = 'Detalhes do produto';
                                          });
                                        },
                                        text: produto.descricao,
                                        gradient: gradient3,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (state is ProdutoLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is ProdutoLoadError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GradientButton(
                        onPressed: () async {
                          _descricaoController.text = '';
                          _estoqueController.text = '';
                          _precoController.text = 'R\$ 0,00';
                          _dataController.text = '';
                          await _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            appBarTitle = 'Adicionar produto';
                          });
                        },
                        text: 'Adicionar',
                        gradient: gradient1,
                      ),
                    ),
                  ],
                ),
                formPage(context),
              ],
            ),
          ),
        ),
      );

  Widget formPage(BuildContext context) {
    if (_produtoSelecionado != null) {
      return BlocBuilder<UpdateProdutoBloc, ProdutoUpdateState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _updateFormKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _descricaoController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe uma descrição';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _precoController,
                          decoration: const InputDecoration(
                            labelText: 'Preço',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe um preço';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _estoqueController,
                          decoration: const InputDecoration(
                            labelText: 'Estoque',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe a quantidade em estoque';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _dataController,
                          decoration: const InputDecoration(
                            labelText: 'Data',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe uma data';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: GradientButton(
                text: 'Voltar',
                gradient: gradient4,
                onPressed: () async {
                  await _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                  _descricaoController.text = '';
                  _estoqueController.text = '';
                  _precoController.text = 'R\$ 0,00';
                  _dataController.text = '';
                  setState(() {
                    appBarTitle = 'Produtos';
                  });
                },
              ),
            ),
            BlocBuilder<DeleteProdutoBloc, ProdutoDeleteState>(
              builder: (context, state) => Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: GradientButton(
                  text: 'Deletar',
                  gradient: gradient2,
                  onPressed: () async {
                    if ((await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirma a deleção do produto?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Sim'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Não'),
                              ),
                            ],
                          ),
                        ) ??
                        false)) {
                      context.read<DeleteProdutoBloc>().add(
                            DeleteProduto(_produtoSelecionado!),
                          );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientButton(
                text: 'Salvar',
                gradient: gradient1,
                onPressed: () async {
                  if (_updateFormKey.currentState!.validate()) {
                    if ((await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                'Confirma a atualização do produto?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Sim'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Não'),
                              ),
                            ],
                          ),
                        ) ??
                        false)) {
                      context.read<UpdateProdutoBloc>().add(
                            UpdateProduto(
                              Produto(
                                id: _produtoSelecionado!.id,
                                descricao: _descricaoController.text,
                                preco: _precoController.numberValue * 10,
                                estoque: int.parse(_estoqueController.text),
                                data:
                                    ptbrStringToDateTime(_dataController.text),
                              ),
                            ),
                          );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return BlocBuilder<CreateProdutoBloc, ProdutoCreateState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _insertFormKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _descricaoController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe uma descrição';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _precoController,
                          decoration: const InputDecoration(
                            labelText: 'Preço',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe um preço';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _estoqueController,
                          decoration: const InputDecoration(
                            labelText: 'Estoque',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe a quantidade em estoque';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _dataController,
                          decoration: const InputDecoration(
                            labelText: 'Data',
                          ),
                          validator: (s) {
                            if (s!.isEmpty) {
                              return 'Informe uma data';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: GradientButton(
                text: 'Cancelar',
                gradient: gradient2,
                onPressed: () async {
                  await _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                  _descricaoController.text = '';
                  _estoqueController.text = '';
                  _precoController.text = 'R\$ 0,00';
                  _dataController.text = '';
                  setState(() {
                    appBarTitle = 'Produtos';
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientButton(
                text: 'Salvar',
                gradient: gradient1,
                onPressed: () async {
                  if (_insertFormKey.currentState!.validate()) {
                    if ((await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title:
                                const Text('Confirma a inserção do produto?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Sim'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Não'),
                              ),
                            ],
                          ),
                        ) ??
                        false)) {
                      context.read<CreateProdutoBloc>().add(
                            CreateProduto(
                              Produto(
                                descricao: _descricaoController.text,
                                preco: _precoController.numberValue * 10,
                                estoque: int.parse(_estoqueController.text),
                                data:
                                    ptbrStringToDateTime(_dataController.text),
                              ),
                            ),
                          );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
