import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_theme.dart';
import '../../data/services/ocr_service.dart';
import '../widgets/feature_card.dart';
import 'help_screen.dart';
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
      appBar: AppBar(
        title: const Text('IncluApp'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HelpScreen()),
            ),
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AppHero(),
              const SizedBox(height: 16),
              const _FeatureCardsRow(),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
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
                const SizedBox(height: 16),
              ],
              const _ButtonDivider(),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _captureFromCamera,
                icon: const Icon(Icons.photo_camera, size: 34, semanticLabel: ''),
                label: const Text('Abrir cámara'),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _isProcessing ? null : _pickFromGallery,
                icon: const Icon(Icons.image_search, size: 32, semanticLabel: ''),
                label: const Text('Elegir imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────
// Icono a la izquierda + título y descripción en columna a la derecha.
// El Row es más compacto que una columna centrada y deja espacio al Expanded.

class _AppHero extends StatelessWidget {
  const _AppHero();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ExcludeSemantics: el icono es decorativo, el texto "IncluApp"
        // ya describe esta sección al lector de pantalla.
        ExcludeSemantics(
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.primaryYellow.withValues(alpha: 0.40),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.document_scanner,
              color: AppTheme.primaryYellow,
              size: 34,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'IncluApp',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Convierte texto a voz\nsin internet ni servidores',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.disabledGray,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tarjetas de funciones ─────────────────────────────────────────────────────
// Row con Expanded en lugar de ListView: las 3 tarjetas siempre visibles.

class _FeatureCardsRow extends StatelessWidget {
  const _FeatureCardsRow();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FeatureCard(
              icon: Icons.wifi_off_rounded,
              title: 'Sin\ninternet',
              description: 'OCR local',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: FeatureCard(
              icon: Icons.record_voice_over_rounded,
              title: 'Voz\nnatural',
              description: 'TTS nativo',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: FeatureCard(
              icon: Icons.lock_outline_rounded,
              title: 'Privado',
              description: 'Solo local',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Estado: listo ─────────────────────────────────────────────────────────────
// Icono circular en lugar de caja rectangular: apariencia más moderna.

class _ReadyState extends StatelessWidget {
  const _ReadyState();

  @override
  Widget build(BuildContext context) {
    // excludeSemantics: true evita que el lector de pantalla anuncie
    // por separado el icono y el texto; solo lee el label combinado.
    return Semantics(
      label: 'Listo para capturar texto. Elige una imagen para comenzar.',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryYellow.withValues(alpha: 0.50),
                width: 2,
              ),
            ),
            child: const Icon(Icons.add_photo_alternate_outlined, size: 36),
          ),
          const SizedBox(height: 12),
          Text(
            'Elige una imagen para comenzar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.disabledGray,
                ),
            textAlign: TextAlign.center,
          ),
        ],
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
      label: 'Procesando texto, por favor espera',
      liveRegion: true,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(strokeWidth: 7),
          ),
          const SizedBox(height: 16),
          Text(
            'Analizando imagen...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// ── Separador entre botones ───────────────────────────────────────────────────

class _ButtonDivider extends StatelessWidget {
  const _ButtonDivider();

  @override
  Widget build(BuildContext context) {
    // ExcludeSemantics: el separador "o" es puramente decorativo;
    // los lectores de pantalla no necesitan anunciarlo.
    return ExcludeSemantics(
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'o',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.disabledGray,
                  ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
