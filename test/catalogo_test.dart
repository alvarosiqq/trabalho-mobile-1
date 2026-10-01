import 'package:catalogo_jogos/main.dart';
import 'package:catalogo_jogos/models/jogo.dart';
import 'package:catalogo_jogos/screens/formulario_jogo_page.dart';
import 'package:catalogo_jogos/widgets/jogo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const jogoA = Jogo(
  id: 'a',
  titulo: 'Hollow Knight',
  plataforma: 'PC',
  genero: 'Aventura',
  situacao: SituacaoJogo.jogando,
);
const jogoB = Jogo(
  id: 'b',
  titulo: 'Hollow Knight',
  plataforma: 'Switch',
  genero: 'Aventura',
  situacao: SituacaoJogo.queroJogar,
);

Future<void> clicar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> preencher(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('titulo')), 'Stardew Valley');
  await tester.enterText(find.byKey(const Key('plataforma')), 'PC');
  await tester.enterText(find.byKey(const Key('genero')), 'Simulação');
}

void main() {
  testWidgets('mostra estado vazio e ação para cadastrar', (tester) async {
    await tester.pumpWidget(const CatalogoApp());
    expect(find.text('Nenhum jogo cadastrado'), findsOneWidget);
    expect(find.byType(JogoCard), findsNothing);
    await clicar(tester, find.text('Adicionar primeiro jogo'));
    expect(find.byType(FormularioJogoPage), findsOneWidget);
  });

  testWidgets('rejeita espaços e cria um jogo com entrada válida', (tester) async {
    await tester.pumpWidget(const CatalogoApp());
    await clicar(tester, find.text('Adicionar primeiro jogo'));
    await tester.enterText(find.byKey(const Key('titulo')), '   ');
    await clicar(tester, find.byKey(const Key('salvar')));
    expect(find.text('Informe o título'), findsOneWidget);
    expect(find.text('Informe a plataforma'), findsOneWidget);
    expect(find.text('Informe o gênero'), findsOneWidget);
    expect(find.byType(FormularioJogoPage), findsOneWidget);
    await preencher(tester);
    await clicar(tester, find.byKey(const Key('salvar')));
    expect(find.byType(JogoCard), findsOneWidget);
    expect(find.text('Stardew Valley'), findsOneWidget);
    expect(find.text('Nenhum jogo cadastrado'), findsNothing);
    expect(find.text('Jogo cadastrado'), findsOneWidget);
  });

  testWidgets('cancelar cadastro não altera a coleção', (tester) async {
    await tester.pumpWidget(const CatalogoApp());
    await clicar(tester, find.text('Adicionar primeiro jogo'));
    await preencher(tester);
    await clicar(tester, find.byKey(const Key('cancelar')));
    expect(find.text('Nenhum jogo cadastrado'), findsOneWidget);
    expect(find.byType(JogoCard), findsNothing);
  });

  testWidgets('detalhe corresponde ao item e edição preserva a identidade', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogoApp(jogosIniciais: [jogoA, jogoB]));
    await clicar(tester, find.byKey(const ValueKey('b')));
    expect(find.text('Switch'), findsOneWidget);
    expect(find.text('Quero jogar'), findsOneWidget);
    await clicar(tester, find.text('Editar jogo'));
    final titulo = tester.widget<TextFormField>(find.byKey(const Key('titulo')));
    expect(titulo.controller!.text, 'Hollow Knight');
    await tester.enterText(find.byKey(const Key('titulo')), 'Hollow Knight - Switch');
    await clicar(tester, find.byKey(const Key('salvar')));
    expect(find.text('Hollow Knight - Switch'), findsOneWidget);
    await clicar(tester, find.byType(BackButton));
    expect(find.byType(JogoCard), findsNWidgets(2));
    final primeiro = tester.widget<JogoCard>(find.byKey(const ValueKey('a')));
    final segundo = tester.widget<JogoCard>(find.byKey(const ValueKey('b')));
    expect(primeiro.jogo.titulo, 'Hollow Knight');
    expect(segundo.jogo.id, 'b');
    expect(segundo.jogo.titulo, 'Hollow Knight - Switch');
  });

  testWidgets('cancelar edição mantém os dados originais', (tester) async {
    await tester.pumpWidget(const CatalogoApp(jogosIniciais: [jogoA]));
    await clicar(tester, find.byKey(const ValueKey('a')));
    await clicar(tester, find.text('Editar jogo'));
    await tester.enterText(find.byKey(const Key('titulo')), 'Alteração cancelada');
    await clicar(tester, find.byKey(const Key('cancelar')));
    expect(find.text('Hollow Knight'), findsOneWidget);
    expect(find.text('Alteração cancelada'), findsNothing);
    await clicar(tester, find.byType(BackButton));
    expect(tester.widget<JogoCard>(find.byType(JogoCard)).jogo.titulo, 'Hollow Knight');
  });

  testWidgets('voltar pelo sistema também propaga a edição', (tester) async {
    await tester.pumpWidget(const CatalogoApp(jogosIniciais: [jogoA]));
    await clicar(tester, find.byKey(const ValueKey('a')));
    await clicar(tester, find.text('Editar jogo'));
    await tester.enterText(find.byKey(const Key('titulo')), 'Hollow Knight editado');
    await clicar(tester, find.byKey(const Key('salvar')));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(JogoCard), findsOneWidget);
    expect(tester.widget<JogoCard>(find.byType(JogoCard)).jogo.titulo,
        'Hollow Knight editado');
  });

  for (final largura in [390.0, 840.0]) {
    testWidgets('lista, detalhe e formulário sem overflow em $largura px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(largura, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        const CatalogoApp(jogosIniciais: [jogoA, jogoB]),
      );
      expect(tester.takeException(), isNull);
      await clicar(tester, find.byKey(const ValueKey('a')));
      expect(tester.takeException(), isNull);
      await clicar(tester, find.text('Editar jogo'));
      await tester.enterText(find.byKey(const Key('titulo')), 'Título longo ' * 7);
      await clicar(tester, find.byKey(const Key('salvar')));
      expect(tester.takeException(), isNull);
      await clicar(tester, find.byType(BackButton));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('texto ampliado não causa overflow na coleção', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      const CatalogoApp(jogosIniciais: [jogoA, jogoB]),
    );
    expect(tester.takeException(), isNull);
  });
}
