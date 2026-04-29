# IncluApp

IncluApp es un Producto Mínimo Viable de accesibilidad para estudiantes con dislexia o baja visión. El caso de estudio se orienta al Colegio Fe y Alegría y a la necesidad de convertir texto impreso en audio de forma simple, privada y sin costos operativos.

## Stack técnico

- Flutter: aplicación móvil multiplataforma para Android/iOS.
- Google ML Kit Text Recognition: reconocimiento óptico de caracteres ejecutado en el dispositivo.
- Flutter TTS: lectura en voz alta mediante el motor nativo del sistema operativo.
- Hive: almacenamiento local para historial de lecturas.
- Image Picker y permisos nativos: captura de imagen desde cámara o galería.

## Arquitectura

```text
lib/
  core/theme/
    app_theme.dart
  data/services/
    ocr_service.dart
    tts_service.dart
  presentation/screens/
    camera_screen.dart
    reader_screen.dart
  main.dart
```

La aplicación separa servicios de datos, presentación y tema visual. Esta estructura permite evolucionar el PMV sin acoplar la interfaz al OCR o al motor de voz.

## Costo de operación: USD 0

IncluApp usa Edge Computing: la imagen se procesa localmente con ML Kit y el audio se genera con el motor TTS del teléfono. No hay Firebase Auth, AWS, Azure, endpoints externos, almacenamiento en la nube ni APIs pagadas. Por eso el costo operativo del PMV es cero y la privacidad mejora porque el contenido académico no sale del dispositivo.

## Accesibilidad

- Fondo negro y controles de alto contraste.
- Botones grandes para facilitar la interacción táctil.
- Tipografía grande y espaciado amplio.
- Feedback háptico en acciones principales.
- Lectura automática del resultado OCR y controles de pausa/detención.

## Ejecución local

```bash
flutter pub get
flutter run
```

Si el repositorio todavía no tiene carpetas nativas `android/` e `ios/`, primero genera el scaffold con Flutter instalado:

```bash
flutter create --platforms=android,ios --project-name incluapp .
```

En Android/iOS se deben mantener habilitados los permisos de cámara y galería:

- Android: `android.permission.CAMERA` y permisos de imágenes según versión del SDK.
- iOS: `NSCameraUsageDescription` y `NSPhotoLibraryUsageDescription` en `Info.plist`.
