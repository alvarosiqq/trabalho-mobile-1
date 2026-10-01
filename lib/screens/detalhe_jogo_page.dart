import 'package:flutter/material.dart';

import '../models/jogo.dart';
import 'formulario_jogo_page.dart';

class DetalheJogoPage extends StatefulWidget {
  const DetalheJogoPage({super.key, required this.jogo});

  final Jogo jogo;

  @override
  State<DetalheJogoPage> createState() => _DetalheJogoPageState();
}

class _DetalheJogoPageState extends State<DetalheJogoPage> {
  late Jogo _jogo;
  bool _alterado = false;

  @override
  void initState() {
    super.initState();
    _jogo = widget.jogo;
  }

  Future<void> _editar() async {
    final resultado = await Navigator.of(context).push<Jogo>(
      MaterialPageRoute(builder: (_) => FormularioJogoPage(jogo: _jogo)),
    );
    if (!mounted || resultado == null) return;
    setState(() {
      _jogo = resultado;
      _alterado = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alterações salvas')),
    );
  }

  @override
  Widget build(BuildContext context) => PopScope<Jogo>(
    canPop: !_alterado,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) Navigator.of(context).pop(_jogo);
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do jogo'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(_alterado ? _jogo : null),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.sports_esports_outlined, size: 64),
                  const SizedBox(height: 20),
                  Semantics(
                    header: true,
                    child: Text(
                      _jogo.titulo,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _campo('Plataforma', _jogo.plataforma),
                  _campo('Gênero', _jogo.genero),
                  _campo('Situação', _jogo.situacao.rotulo),
                  _campo(
                    'Observações',
                    _jogo.observacoes.isEmpty
                        ? 'Nenhuma observação informada.'
                        : _jogo.observacoes,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _editar,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar jogo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _campo(String rotulo, String valor) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rotulo, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(valor, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}
