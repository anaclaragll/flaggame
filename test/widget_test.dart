import 'package:flutter_test/flutter_test.dart';
import 'package:flag_game/main.dart';

void main() {
  testWidgets('exibe o menu principal', (WidgetTester tester) async {
    await tester.pumpWidget(const FlagGameApp());
    expect(find.text('FLAG'), findsOneWidget);
    expect(find.text('GAME'), findsOneWidget);
    expect(find.text('Jogar por continente'), findsOneWidget);
    expect(find.text('Jogo aleatório'), findsOneWidget);
  });
}
