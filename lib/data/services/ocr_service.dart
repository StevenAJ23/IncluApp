import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  OcrService()
      : _textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        );

  final TextRecognizer _textRecognizer;

  // Procesamiento local: ML Kit corre en el dispositivo y no envía la imagen a la nube.
  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.trim().isEmpty) {
        return 'No se detectó texto en la imagen. Intenta otra vez con mejor iluminación y el documento bien enfocado.';
      }

      final buffer = StringBuffer();

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          buffer.writeln(line.text);
        }
        buffer.writeln();
      }

      return buffer.toString().trim();
    } catch (error) {
      return 'Error al procesar la imagen de forma local: $error';
    }
  }

  // ML Kit no expone confianza por caracter en esta API; esta métrica ayuda a estimar densidad de texto.
  Future<double> estimateTextDensity(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final recognizedText = await _textRecognizer.processImage(inputImage);

      var elementCount = 0;
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          elementCount += line.elements.length;
        }
      }

      return (elementCount / (elementCount + 8)).clamp(0.0, 1.0).toDouble();
    } catch (_) {
      return 0.0;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
