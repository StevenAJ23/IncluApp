import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_theme.dart';
import '../../data/services/ocr_service.dart';
import '../widgets/feature_card.dart';
import 'reader_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final OcrService _ocrService = OcrService();

  bool _isProcessing = false;
  String? _statusMessage;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _captureFromCamera() async {
    await _pickAndProcessImage(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    await _pickAndProcessImage(ImageSource.gallery);
  }

  Future<void> _pickAndProcessImage(ImageSource source) async {
    await HapticFeedback.mediumImpact();

    final hasPermission = await _ensurePermission(source);
    if (!hasPermission) {
      _showMessage('Permiso no concedido. Revisa los ajustes del dispositivo.');
      return;
    }

    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 92,
      maxWidth: 1800,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Procesando texto en el dispositivo...';
    });

    final stopwatch = Stopwatch()..start();
    final extractedText = await _ocrService.extractTextFromImage(image.path);
    stopwatch.stop();

    if (!mounted) {
      return;
    }

    await _saveReading(
      text: extractedText,
      imagePath: image.path,
      processingMs: stopwatch.elapsedMilliseconds,
    );

    setState(() {
      _isProcessing = false;
      _statusMessage = null;
    });

    await HapticFeedback.heavyImpact();

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReaderScreen(
          extractedText: extractedText,
          imagePath: image.path,
          processingMs: stopwatch.elapsedMilliseconds,
        ),
      ),
    );
  }

  Future<bool> _ensurePermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      return status.isGranted || status.isLimited;
    }

    return true;
  }

  Future<void> _saveReading({
    required String text,
    required String imagePath,
    required int processingMs,
  }) async {
    final box = Hive.box<Map>('reading_history');
    await box.add({
      'text': text,
      'imagePath': imagePath,
      'processingMs': processingMs,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IncluApp')),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AppHero(),
              const SizedBox(height: AppTheme.elementSpacing),
              const _FeatureCardsRow(),
              const SizedBox(height: AppTheme.elementSpacing),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _isProcessing
                        ? const _ProcessingState()
                        : const _ReadyState(),
                  ),
                ),
              ),
              if (_statusMessage != null) ...[
                Text(
                  _statusMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.elementSpacing),
              ],
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _captureFromCamera,
                icon: const Icon(Icons.photo_camera, size: 34),
                label: const Text('Abrir cámara'),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _isProcessing ? null : _pickFromGallery,
                icon: const Icon(Icons.image_search, size: 32),
                label: const Text('Elegir imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero de la pantalla principal ─────────────────────────────────────────────

class _AppHero extends StatelessWidget {
  const _AppHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.document_scanner,
                color: AppTheme.primaryYellow,
                size: 38,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'IncluApp',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Diseñada para personas con dislexia\ny baja visión. Sin internet. Sin nubes.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.disabledGray,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Fila de tarjetas de funciones ─────────────────────────────────────────────

class _FeatureCardsRow extends StatelessWidget {
  const _FeatureCardsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          FeatureCard(
            icon: Icons.wifi_off_rounded,
            title: 'Sin internet',
            description: 'OCR 100% local',
          ),
          FeatureCard(
            icon: Icons.record_voice_over_rounded,
            title: 'Voz natural',
            description: 'TTS nativo',
          ),
          FeatureCard(
            icon: Icons.lock_outline_rounded,
            title: 'Privado',
            description: 'Todo en tu dispositivo',
          ),
        ],
      ),
    );
  }
}

// ── Estado: listo para capturar ───────────────────────────────────────────────

class _ReadyState extends StatelessWidget {
  const _ReadyState();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Listo para capturar texto',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.primaryYellow, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.document_scanner, size: 72),
            const SizedBox(height: 16),
            Text(
              'Listo para leer',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Captura o selecciona una imagen\ncon texto para comenzar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.disabledGray,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Estado: procesando OCR ────────────────────────────────────────────────────

class _ProcessingState extends StatelessWidget {
  const _ProcessingState();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Procesando texto',
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(strokeWidth: 7),
          ),
          const SizedBox(height: 20),
          Text(
            'Analizando imagen...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
