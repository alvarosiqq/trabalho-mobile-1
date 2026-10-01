import 'package:flutter/material.dart';

import '../models/jogo.dart';

class JogoCard extends StatelessWidget {
  const JogoCard({super.key, required this.jogo, required this.onAbrir});

  final Jogo jogo;
  final VoidCallback onAbrir;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Semantics(
      button: true,
      label:
          'Abrir detalhes de ${jogo.titulo}, ${jogo.plataforma}, ${jogo.situacao.rotulo}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onAbrir,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sports_esports,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jogo.titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text('${jogo.plataforma} • ${jogo.genero}'),
                    const SizedBox(height: 8),
                    Text(
                      jogo.situacao.rotulo,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ),
  );
}
