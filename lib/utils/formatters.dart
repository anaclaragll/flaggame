String durationLabel(int seconds) {
  if (seconds < 60) return '$seconds segundos';
  final minutes = seconds ~/ 60;
  return minutes == 1 ? '1 minuto' : '$minutes minutos';
}

String formatTime(int seconds) {
  return '${(seconds ~/ 60).toString().padLeft(2, '0')}:'
      '${(seconds % 60).toString().padLeft(2, '0')}';
}
