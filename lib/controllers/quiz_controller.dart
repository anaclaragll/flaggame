import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/country.dart';
import '../models/game_config.dart';
import '../models/quiz_question.dart';
import '../services/game_service.dart';

class QuizController extends ChangeNotifier {
  final GameConfig config;
  final GameService gameService;
  final void Function()? onFinished;

  late List<Country> _pool;
  late QuizQuestion question;
  Timer? _timer;
  int remaining;
  int score = 0;
  int answered = 0;
  bool locked = false;
  String? selectedAnswer;
  bool? wasCorrect;
  bool _finished = false;

  QuizController({
    required this.config,
    GameService? gameService,
    this.onFinished,
  })  : gameService = gameService ?? GameService(),
        remaining = config.duration {
    _start();
  }

  double get progress => remaining / config.duration;//progress: porcentagem de tempo restante do jogo.
  Country get current => question.answer;
  List<Country> get options => question.options;
  bool get isFinished => _finished;

  void _start() {
    _pool = gameService.loadPool(config);
    _nextQuestion();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_finished) return;
    if (remaining <= 1) {
      remaining = 0;
      notifyListeners();
      finish();
      return;
    }
    remaining--;
    notifyListeners();
  }
//pool: lista de países disponíveis para o quiz. question: pergunta atual do quiz.
  void _nextQuestion() {//FUNÇÃO QUE GERA A PRÓXIMA PERGUNTA DO QUIZ
    if (_pool.isEmpty) _pool = gameService.loadPool(config);//VERIFICA SE O POOL DE PAÍSES ESTÁ VAZIO, SE SIM, CARREGA NOVAMENTE O POOL DE PAÍSES DISPONÍVEIS PARA O QUIZ
    final answer = _pool.removeLast();//answer: resposta correta.
    question = gameService.createQuestion(//CRIA UMA NOVA PERGUNTA DO QUIZ COM A RESPOSTA CORRETA E AS ALTERNATIVAS INCORRETAS
      answer: answer,//answer: resposta correta.
      allCountries: gameService.countryRepository.findByContinent(null),//allCountries: lista de todos os países disponíveis no repositório de países, sem filtro por continente.
    );
    locked = false;
    selectedAnswer = null;
    wasCorrect = null;
  }
//. Como o sistema identifica a resposta correta?
  void answer(Country answer) {//FUNÇÃO QUE É CHAMADA QUANDO O USUÁRIO RESPONDE A PERGUNTA
    if (locked || remaining == 0 || _finished) return;//VERIFICA SE O JOGO ESTÁ BLOQUEADO, SE O TEMPO ACABOU OU SE O JOGO TERMINOU
    locked = true;//BLOQUEIA O JOGO PARA QUE O USUÁRIO NÃO POSSA RESPONDER NOVAMENTE
    selectedAnswer = answer.name;//ARMAZENA O NOME DO PAÍS SELECIONADO PELO USUÁRIO
    wasCorrect = answer.name == current.name;//VERIFICA SE A RESPOSTA ESTÁ CORRETA
    answered++;//INCREMENTA O NÚMERO DE PERGUNTAS RESPONDIDAS
    if (wasCorrect!) score++;//INCREMENTA A PONTUAÇÃO SE A RESPOSTA ESTIVER CORRETA
    notifyListeners();  //ATUALIZA A TELA COM A NOVA PONTUAÇÃO E O RESULTADO DA RESPOSTA

//8. Como o jogo passa para a próxima pergunta?
    Future<void>.delayed(const Duration(milliseconds: 650), () {//AGUARDA 650 MILISSEGUNDOS PARA MOSTRAR O RESULTADO DA RESPOSTA ANTES DE PASSAR PARA A PRÓXIMA PERGUNTA
      if (_finished || remaining == 0) return;//VERIFICA SE O JOGO TERMINOU OU SE O TEMPO ACABOU
      _nextQuestion();//PASSA PARA A PRÓXIMA PERGUNTA
      notifyListeners();//ATUALIZA A TELA COM A NOVA PERGUNTA
    });
  }

  void finish() {//FUNÇÃO QUE É CHAMADA QUANDO O JOGO TERMINA
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    onFinished?.call();
  }

  @override
  void dispose() {//FUNÇÃO QUE É CHAMADA QUANDO O QUIZ CONTROLLER É DESCARTADO
    _timer?.cancel();
    super.dispose();
  }
}
