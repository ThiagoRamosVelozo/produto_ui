import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                                      onPressed: () {},
                                      text: produto.nome,
                                      gradient: gradient0,
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
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocBuilder<CreateProdutoBloc, ProdutoState>(
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
                                      onPressed: () {},
                                      text: produto.nome,
                                      gradient: gradient0,
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
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: GradientButton(
                      text: 'Cancelar',
                      gradient: gradient2,
                      onPressed: () async {
                        await _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
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
                        await _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          appBarTitle = 'Produtos';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
