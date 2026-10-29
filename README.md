# Flag Game

Aplicativo Flutter educativo para testar conhecimentos sobre bandeiras e países. O jogador pode iniciar uma partida com países de um continente específico ou com países do mundo todo.

## Funcionalidades

- Menu principal com modo por continente e modo aleatório.
- Continentes: África, América, Ásia, Europa e Oceania.
- Configuração de tempo: 30 segundos, 60 segundos, 3 minutos ou 5 minutos.
- Quatro alternativas por pergunta.
- Cronômetro regressivo e encerramento automático quando o tempo acaba.
- Feedback visual de acerto/erro.
- Pontuação, total de perguntas e percentual de acertos.
- Ranking local persistido com `shared_preferences`.
- Banco de dados local com 194 países organizados por continente.
- Ranking local com nome do jogador e pontuação, exibido no menu e no resultado.
- Interface responsiva com tema claro e bandeiras em emoji, sem depender de internet ou imagens externas.

## Como executar

1. Instale o Flutter 3.x e confirme com `flutter doctor`.
2. Entre na pasta do projeto:

   ```bash
   cd FlagGame
   ```

3. Baixe as dependências:

   ```bash
   flutter pub get
   ```

4. Execute em um dispositivo ou emulador:

   ```bash
   flutter run
   ```

Para executar no navegador:

```bash
flutter run -d chrome
```

## Estrutura

- `lib/main.dart` e `lib/app.dart`: ponto de entrada e configuração global do aplicativo.
- `lib/models/`: entidades e configurações do domínio.
- `lib/data/`: banco local de países e continentes.
- `lib/services/`: persistência do ranking local com `shared_preferences`.
- `lib/screens/`: telas de menu, configuração, quiz e resultado.
- `lib/widgets/`: componentes reutilizáveis da interface.
- `lib/utils/`: formatadores e ícones compartilhados.
- `pubspec.yaml`: dependências e configuração do aplicativo.
- `test/widget_test.dart`: teste de inicialização e quantidade de países.

## Recursos utilizados

- Flutter Material 3.
- `Navigator` para navegação entre telas.
- `setState` para o gerenciamento do estado da partida.
- `shared_preferences` para salvar o ranking local.
- Emojis Unicode para representar as bandeiras sem assets externos.

## Observações

O projeto foi preparado para ser aberto no Android Studio, VS Code ou diretamente no GitHub/CodeSpaces com Flutter instalado. O banco local contém 194 países na lista `countries` em `lib/data/country_data.dart`. Ao terminar uma partida, informe seu nome para salvar a pontuação no ranking da tela inicial.
