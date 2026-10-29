import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class SettingsScreen extends StatefulWidget {
  final int initial;

  const SettingsScreen({super.key, required this.initial});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int selected;
  final durations = const [30, 60, 180, 300];

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuração do tempo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.timer_outlined,
                size: 46, color: Color(0xFFB49CFF)),
            const SizedBox(height: 18),
            Text('Quanto tempo você quer?',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Escolha o tempo total disponível para cada partida.',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 28),
            RadioGroup<int>(
              groupValue: selected,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selected = value);
                }
              },
              child: Column(
                children: [
                  ...durations.map(
                    (duration) => RadioListTile<int>(
                      value: duration,
                      title: Text(durationLabel(duration)),
                      subtitle: Text(duration == 30
                          ? 'Desafio rápido'
                          : duration == 300
                              ? 'Partida tranquila'
                              : 'Equilíbrio ideal'),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, selected),
                    icon: const Icon(Icons.check),
                    label: const Text('Salvar configuração'))),
          ],
        ),
      ),
    );
  }
}
