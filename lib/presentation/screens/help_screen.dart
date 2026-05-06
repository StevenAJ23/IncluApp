import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: ListView(
        padding: AppTheme.screenPadding,
        children: [
          _HelpCard(
            icon: Icons.info_outline_rounded,
            title: '¿Qué es IncluApp?',
            children: const [
              _BodyText(
                'IncluApp es una herramienta de accesibilidad para personas con '
                'dislexia o baja visión. Convierte cualquier texto en imágenes a '
                'voz de forma 100% local, sin internet ni servidores externos. '
                'Todo el procesamiento ocurre en tu dispositivo.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _HelpCard(
            icon: Icons.play_circle_outline_rounded,
            title: '¿Cómo empezar?',
            children: const [
              _StepItem(
                step: 1,
                text: 'En la pantalla principal pulsa "Abrir cámara".',
              ),
              _StepItem(
                step: 2,
                text: 'Apunta la cámara al texto que deseas escuchar.',
              ),
              _StepItem(
                step: 3,
                text: 'La app procesa la imagen y extrae el texto automáticamente.',
              ),
              _StepItem(
                step: 4,
                text: 'El texto se leerá en voz alta al abrir la pantalla de resultados.',
              ),
              _StepItem(
                step: 5,
                text: 'También puedes usar "Elegir imagen" para seleccionar desde tu galería.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _HelpCard(
            icon: Icons.star_outline_rounded,
            title: 'Funciones principales',
            children: const [
              _FeatureItem(
                icon: Icons.document_scanner_outlined,
                label: 'Reconocimiento de texto (OCR)',
                detail: 'Detecta y extrae texto de cualquier imagen sin conexión.',
              ),
              _FeatureItem(
                icon: Icons.record_voice_over_outlined,
                label: 'Texto a voz (TTS)',
                detail: 'Lee el texto extraído con voz natural en español.',
              ),
              _FeatureItem(
                icon: Icons.speed_outlined,
                label: 'Velocidad ajustable',
                detail: 'Controla la velocidad de lectura desde la pantalla de resultados.',
              ),
              _FeatureItem(
                icon: Icons.lock_outline_rounded,
                label: 'Privacidad total',
                detail: 'Ningún dato se envía fuera del dispositivo.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _HelpCard(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Recomendaciones de uso',
            children: const [
              _TipItem('Fotografía con buena iluminación para mejorar la precisión del OCR.'),
              _TipItem('Coloca el texto horizontal y sin inclinación para mejores resultados.'),
              _TipItem('El texto impreso se reconoce mejor que el manuscrito.'),
              _TipItem('Si el audio se detiene, usa el botón "Repetir" en la pantalla de resultados.'),
              _TipItem('Para textos largos, reduce la velocidad de lectura para seguirla con más facilidad.'),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Tarjeta de sección ────────────────────────────────────────────────────────

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryYellow.withValues(alpha: 0.22),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                // Icono decorativo: el título ya describe la sección.
                ExcludeSemantics(
                  child: Icon(icon, color: AppTheme.primaryYellow, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets de contenido ──────────────────────────────────────────────────────

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.step, required this.text});
  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // El número del paso se anuncia como "Paso N" en lugar de solo el dígito.
          Semantics(
            label: 'Paso $step',
            excludeSemantics: true,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryYellow, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: const TextStyle(
                    color: AppTheme.primaryYellow,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono decorativo: el label de texto ya nombra la función.
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, color: AppTheme.primaryYellow, size: 26),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.disabledGray,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet decorativo: no aporta información al lector de pantalla.
          ExcludeSemantics(
            child: const Padding(
              padding: EdgeInsets.only(top: 9),
              child: Icon(Icons.circle, color: AppTheme.primaryYellow, size: 7),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
