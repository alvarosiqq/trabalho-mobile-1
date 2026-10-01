import 'package:flutter/material.dart';

import 'models/jogo.dart';
import 'screens/lista_jogos_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(const CatalogoApp());

class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key, this.jogosIniciais = const []});

  final List<Jogo> jogosIniciais;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Meu Catálogo de Jogos',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.claro,
    home: ListaJogosPage(jogosIniciais: jogosIniciais),
  );
}
