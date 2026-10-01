import 'package:flutter/material.dart';

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({super.key, required this.onAdicionar});

  final VoidCallback onAdicionar;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sports_esports_outlined, size: 72),
          const SizedBox(height: 16),
          Text(
            'Nenhum jogo cadastrado',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione seu primeiro jogo para começar o catálogo.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdicionar,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar primeiro jogo'),
          ),
        ],
      ),
    ),
  );
}
