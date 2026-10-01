import 'package:flutter/material.dart';

import '../models/jogo.dart';

class FormularioJogoPage extends StatefulWidget {
  const FormularioJogoPage({super.key, this.jogo, this.idNovo})
    : assert(jogo != null || idNovo != null);

  final Jogo? jogo;
  final String? idNovo;

  @override
  State<FormularioJogoPage> createState() => _FormularioJogoPageState();
}

class _FormularioJogoPageState extends State<FormularioJogoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _plataforma;
  late final TextEditingController _genero;
  late final TextEditingController _observacoes;
  late SituacaoJogo _situacao;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.jogo?.titulo ?? '');
    _plataforma = TextEditingController(text: widget.jogo?.plataforma ?? '');
    _genero = TextEditingController(text: widget.jogo?.genero ?? '');
    _observacoes = TextEditingController(text: widget.jogo?.observacoes ?? '');
    _situacao = widget.jogo?.situacao ?? SituacaoJogo.queroJogar;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _plataforma.dispose();
    _genero.dispose();
    _observacoes.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final jogo = Jogo(
      id: widget.jogo?.id ?? widget.idNovo!,
      titulo: _titulo.text.trim(),
      plataforma: _plataforma.text.trim(),
      genero: _genero.text.trim(),
      situacao: _situacao,
      observacoes: _observacoes.text.trim(),
    );
    Navigator.of(context).pop(jogo);
  }

  String? _obrigatorio(String? valor, String mensagem) =>
      valor == null || valor.trim().isEmpty ? mensagem : null;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.jogo == null ? 'Cadastrar jogo' : 'Editar jogo'),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const Key('titulo'),
                    controller: _titulo,
                    decoration: const InputDecoration(labelText: 'Título'),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                    validator: (valor) => _obrigatorio(valor, 'Informe o título'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('plataforma'),
                    controller: _plataforma,
                    decoration: const InputDecoration(
                      labelText: 'Plataforma',
                      hintText: 'Ex.: PC, PlayStation, Xbox',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    validator: (valor) =>
                        _obrigatorio(valor, 'Informe a plataforma'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('genero'),
                    controller: _genero,
                    decoration: const InputDecoration(labelText: 'Gênero'),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    validator: (valor) => _obrigatorio(valor, 'Informe o gênero'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SituacaoJogo>(
                    key: const Key('situacao'),
                    initialValue: _situacao,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Situação'),
                    items: [
                      for (final situacao in SituacaoJogo.values)
                        DropdownMenuItem(
                          value: situacao,
                          child: Text(situacao.rotulo),
                        ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) setState(() => _situacao = valor);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('observacoes'),
                    controller: _observacoes,
                    decoration: const InputDecoration(
                      labelText: 'Observações (opcional)',
                    ),
                    minLines: 2,
                    maxLines: 4,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: const Key('salvar'),
                    onPressed: _salvar,
                    icon: const Icon(Icons.check),
                    label: const Text('Salvar jogo'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    key: const Key('cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
