enum SituacaoJogo {
  queroJogar('Quero jogar'),
  jogando('Jogando'),
  concluido('Concluído');

  const SituacaoJogo(this.rotulo);
  final String rotulo;
}

class Jogo {
  const Jogo({
    required this.id,
    required this.titulo,
    required this.plataforma,
    required this.genero,
    required this.situacao,
    this.observacoes = '',
  });

  final String id;
  final String titulo;
  final String plataforma;
  final String genero;
  final SituacaoJogo situacao;
  final String observacoes;
}
