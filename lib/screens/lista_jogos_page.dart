import 'package:flutter/material.dart';

import '../models/jogo.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/jogo_card.dart';
import 'detalhe_jogo_page.dart';
import 'formulario_jogo_page.dart';

class ListaJogosPage extends StatefulWidget {
  const ListaJogosPage({super.key, this.jogosIniciais = const []});

  final List<Jogo> jogosIniciais;

  @override
  State<ListaJogosPage> createState() => _ListaJogosPageState();
}

class _ListaJogosPageState extends State<ListaJogosPage> {
  late final List<Jogo> _jogos;
  int _proximoId = 1;

  @override
  void initState() {
    super.initState();
    _jogos = List.of(widget.jogosIniciais);
  }

  String _novoId() {
    while (_jogos.any((jogo) => jogo.id == 'jogo-$_proximoId')) {
      _proximoId++;
    }
    return 'jogo-${_proximoId++}';
  }

  Future<void> _adicionar() async {
    final novoJogo = await Navigator.of(context).push<Jogo>(
      MaterialPageRoute(
        builder: (_) => FormularioJogoPage(idNovo: _novoId()),
      ),
    );
    if (!mounted || novoJogo == null) return;
    setState(() => _jogos.add(novoJogo));
    _confirmar('Jogo cadastrado');
  }

  Future<void> _abrir(Jogo jogo) async {
    final atualizado = await Navigator.of(context).push<Jogo>(
      MaterialPageRoute(builder: (_) => DetalheJogoPage(jogo: jogo)),
    );
    if (!mounted || atualizado == null) return;
    final indice = _jogos.indexWhere((item) => item.id == atualizado.id);
    if (indice < 0) return;
    setState(() => _jogos[indice] = atualizado);
    _confirmar('Jogo atualizado');
  }

  void _confirmar(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Meu Catálogo de Jogos')),
    body: SafeArea(
      child: _jogos.isEmpty
          ? EstadoVazio(onAdicionar: _adicionar)
          : LayoutBuilder(
              builder: (context, constraints) {
                final duasColunas = constraints.maxWidth >= 700;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${_jogos.length} jogo(s) no catálogo',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    for (var i = 0; i < _jogos.length; i += duasColunas ? 2 : 1)
                      if (duasColunas)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _card(_jogos[i])),
                            const SizedBox(width: 8),
                            Expanded(
                              child: i + 1 < _jogos.length
                                  ? _card(_jogos[i + 1])
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        )
                      else
                        _card(_jogos[i]),
                  ],
                );
              },
            ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _adicionar,
      tooltip: 'Adicionar jogo',
      icon: const Icon(Icons.add),
      label: const Text('Adicionar jogo'),
    ),
  );

  Widget _card(Jogo jogo) => JogoCard(
    key: ValueKey(jogo.id),
    jogo: jogo,
    onAbrir: () => _abrir(jogo),
  );
}
