import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/services/tts_service.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    required this.extractedText,
    required this.imagePath,
    required this.processingMs,
    super.key,
  });

  final String extractedText;
  final String imagePath;
  final int processingMs;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final TtsService _ttsService = TtsService();
  double _speechRate = 0.45;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speak();
    });
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    await HapticFeedback.selectionClick();
    final started = await _ttsService.speak(widget.extractedText);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSpeaking = started;
    });
  }

  Future<void> _pause() async {
    await HapticFeedback.selectionClick();
    await _ttsService.pause();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSpeaking = false;
    });
  }

  Future<void> _stop() async {
    await HapticFeedback.mediumImpact();
    await _ttsService.stop();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSpeaking = false;
    });
  }

  Future<void> _changeSpeechRate(double value) async {
    setState(() {
      _speechRate = value;
    });
    await _ttsService.setSpeechRate(value);
  }

  @override
  Widget build(BuildContext context) {
    final seconds = (widget.processingMs / 1000).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('Lectura')),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Resultado OCR',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Procesado en $seconds s',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.elementSpacing),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    border: Border.all(color: AppTheme.accentWhite, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      widget.extractedText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Velocidad',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Slider(
                value: _speechRate,
                min: 0.25,
                max: 0.8,
                divisions: 11,
                label: _speechRate.toStringAsFixed(2),
                onChanged: _changeSpeechRate,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _speak,
                icon: Icon(_isSpeaking ? Icons.replay : Icons.volume_up),
                label: Text(_isSpeaking ? 'Repetir lectura' : 'Leer texto'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pause,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pausar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _stop,
                      icon: const Icon(Icons.stop),
                      label: const Text('Detener'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
