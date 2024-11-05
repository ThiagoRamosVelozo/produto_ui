import 'package:flutter/material.dart';
import './pages/produto_crud.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Produto App',
      home: ProdutoCrud(),
    );
  }
}
