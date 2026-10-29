import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/country_data.dart';
import '../models/game_config.dart';
import '../utils/continent_icons.dart';
import '../utils/formatters.dart';
import '../widgets/mode_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDuration = 60;

  Future<void> _openGame(GameConfig config) async {
    await Navigator.push(context, AppRoutes.quiz(config));
    if (mounted) setState(() {});
  }

  void _chooseContinent() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Escolha um continente',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...continents.map(
                (continent) => ListTile(
                  leading: Icon(continentIcon(continent)),
                  title: Text(continent),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    _openGame(GameConfig(
                        continent: continent, duration: selectedDuration));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FLAG',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  letterSpacing: 4, color: Colors.white70)),
                      Text('GAME',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFB49CFF))),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Configurar tempo',
                    icon: const Icon(Icons.tune_rounded),
                    onPressed: () async {
                      final result = await Navigator.push<int>(
                        context,
                        AppRoutes.settings(selectedDuration),
                      );
                      if (result != null) {
                        setState(() => selectedDuration = result);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 38),
              Text('Teste seu conhecimento\ndo mundo!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, height: 1.15)),
              const SizedBox(height: 12),
              Text('Identifique as bandeiras antes que o tempo acabe.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white60)),
              const SizedBox(height: 30),
              _buildHeroCard(),
              const SizedBox(height: 20),
              Text('Escolha como jogar',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ModeCard(
                  icon: Icons.public,
                  title: 'Jogar por continente',
                  subtitle: 'Foque em uma região do planeta',
                  color: const Color(0xFF6C63FF),
                  onTap: _chooseContinent),
              const SizedBox(height: 12),
              ModeCard(
                  icon: Icons.shuffle_rounded,
                  title: 'Jogo aleatório',
                  subtitle: 'Uma viagem por todos os continentes',
                  color: const Color(0xFFFF9F43),
                  onTap: () =>
                      _openGame(GameConfig(duration: selectedDuration))),
              const SizedBox(height: 22),
              Center(
                  child: Text(
                      'Tempo atual: ${durationLabel(selectedDuration)}  •  ${countries.length} países disponíveis',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white54))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
            colors: [Color(0xFF272447), Color(0xFF1E243D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Row(
        children: [
          const Expanded(
              child: Text('🌍  🗺️  🚩',
                  style: TextStyle(fontSize: 31, height: 1.5))),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${countries.length}',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const Text('bandeiras', style: TextStyle(color: Colors.white60))
          ]),
        ],
      ),
    );
  }
}
