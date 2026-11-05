import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../controllers/quiz_controller.dart';
import '../models/country.dart';
import '../models/game_config.dart';
import '../utils/formatters.dart';

class QuizScreen extends StatefulWidget {
  final GameConfig config;

  const QuizScreen({super.key, required this.config});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizController controller;

  @override
  void initState() {
    super.initState();
    controller = QuizController(
      config: widget.config,
      onFinished: _finish,
    );
  }

  void _finish() {//FUNÇÃO QUE É CHAMADA QUANDO O JOGO TERMINA
    if (!mounted) return;//VERIFICA SE O WIDGET AINDA ESTÁ MONTADO NA ÁRVORE DE WIDGETS
    Navigator.pushReplacement(  //SUBSTITUI A TELA ATUAL PELA TELA DE RESULTADOS
      context,//context: contexto da tela atual
      AppRoutes.result(//AppRoutes.result: rota para a tela de resultados
        score: controller.score,//score: pontuação final do jogador
        answered: controller.answered,//answered: número de perguntas respondidas pelo jogador
        config: widget.config,//config: configuração do jogo atual
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: controller.finish,
          ),
          title: Text(widget.config.continent ?? 'Mundo todo'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Center(
                child: Text(
                  '${controller.score} pts',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              children: [
                _ProgressHeader(controller: controller),
                const SizedBox(height: 24),
                Expanded(child: _QuestionContent(controller: controller)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final QuizController controller;

  const _ProgressHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer_outlined, size: 19),
        const SizedBox(width: 7),
        Text(
          formatTime(controller.remaining),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: controller.progress,
              minHeight: 9,
              color: controller.remaining <= 10
                  ? Colors.redAccent
                  : const Color(0xFFB49CFF),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${controller.answered} respondidas',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _QuestionContent extends StatelessWidget {
  final QuizController controller;

  const _QuestionContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Qual país usa esta bandeira?',//PERGUNTA QUE APARECE NA TELA DE QUIZ
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1E2B),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFF34374B)),
            ),
            child: Column(
              children: [
                Text(controller.current.flag,   //BANDEIRA DO PAÍS QUE APARECE NA TELA DE QUIZ
                    style: const TextStyle(fontSize: 92)),
                const SizedBox(height: 12),
                Text(
                  'PERGUNTA ${controller.answered + 1}',
                  style: const TextStyle(
                    letterSpacing: 2,
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...controller.options.map(
            (option) => _AnswerButton(
              option: option,
              controller: controller,
            ),
          ),
          if (controller.wasCorrect != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                controller.wasCorrect!
                    ? 'Muito bem! +1 ponto'
                    : 'A resposta era ${controller.current.name}',
                style: TextStyle(
                  color: controller.wasCorrect!
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final Country option;
  final QuizController controller;

  const _AnswerButton({required this.option, required this.controller});
//7. Como o jogo mostra se o jogador acertou ou errou?
  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedAnswer == option.name;//VERIFICA SE A OPÇÃO SELECIONADA PELO USUÁRIO É A MESMA QUE A OPÇÃO ATUAL
    final isCorrect = option.name == controller.current.name;//VERIFICA SE A OPÇÃO ATUAL É A RESPOSTA CORRETA
    Color? color;//VARIÁVEL QUE ARMAZENA A COR DO BOTÃO DE RESPOSTA, DEPENDENDO SE A RESPOSTA ESTÁ CORRETA OU INCORRETA
    if (controller.locked && isCorrect) {   //VERIFICA SE O JOGO ESTÁ BLOQUEADO E SE A OPÇÃO ATUAL É A RESPOSTA CORRETA
      color = Colors.green.withValues(alpha: .24);//SE SIM, A COR DO BOTÃO É VERDE
    }
    if (controller.locked && isSelected && !isCorrect) {//VERIFICA SE O JOGO ESTÁ BLOQUEADO, SE A OPÇÃO ATUAL É A OPÇÃO SELECIONADA PELO USUÁRIO E SE NÃO É A RESPOSTA CORRETA
      color = Colors.red.withValues(alpha: .24);//SE SIM, A COR DO BOTÃO É VERMELHA
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        onPressed: controller.locked ? null : () => controller.answer(option),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          side: BorderSide(color: color ?? const Color(0xFF35384C)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            if (controller.locked && isCorrect)
              const Icon(Icons.check_circle, color: Colors.greenAccent),
            if (controller.locked && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}
