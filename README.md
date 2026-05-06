# IncluApp

> Aplicación móvil de accesibilidad con reconocimiento óptico de caracteres (OCR) local y síntesis de voz (TTS) nativa, desarrollada con Flutter y Dart.

---

## 1. Descripción general

**IncluApp** es un Producto Mínimo Viable (PMV) de accesibilidad orientado a estudiantes con dislexia o baja visión. El caso de estudio se contextualiza en el **Colegio Fe y Alegría**, institución educativa que atiende a poblaciones con necesidades especiales de aprendizaje.

La aplicación permite fotografiar cualquier texto impreso —libros, pizarras, hojas de trabajo— y escucharlo en voz alta de manera inmediata. Todo el procesamiento ocurre en el propio dispositivo: no se transmite información a servidores externos, no se requiere conexión a internet durante el uso y el costo operativo del PMV es **USD 0**.

---

## 2. Objetivo de la aplicación

Reducir la barrera de acceso al contenido escrito para estudiantes con dislexia o baja visión mediante una herramienta que:

- Extrae texto de imágenes usando OCR completamente local (Google ML Kit).
- Lee el texto extraído en voz alta con el motor de síntesis de voz nativo del dispositivo.
- Ofrece una interfaz de alto contraste, tipografía accesible y controles táctiles amplios.
- Garantiza la privacidad del contenido académico al no requerir ningún servicio externo.

---

## 3. Stack tecnológico

| Tecnología | Versión | Rol en el proyecto |
|---|---|---|
| **Flutter** | ≥ 3.0 | Framework de UI multiplataforma (Android / iOS / Web) |
| **Dart** | ≥ 3.0.0 < 4.0.0 | Lenguaje de programación principal |
| **google_mlkit_text_recognition** | ^0.13.0 | OCR local — extracción de texto sin conexión |
| **flutter_tts** | ^4.0.2 | Síntesis de voz nativa (Text-To-Speech) |
| **hive** / **hive_flutter** | ^2.2.3 / ^1.1.0 | Base de datos local para historial de lecturas |
| **image_picker** | ^1.1.2 | Captura de imágenes desde cámara o galería |
| **camera** | ^0.11.0+2 | Acceso directo a la cámara del dispositivo |
| **permission_handler** | ^11.3.1 | Gestión de permisos en tiempo de ejecución |
| **path_provider** | ^2.1.3 | Acceso al sistema de archivos local |

> **Sin backend.** No se utilizan Firebase, AWS, Azure, APIs de pago ni ningún servicio externo. El diseño sigue el principio de *Edge Computing*: todo el procesamiento ocurre en el dispositivo.

---

## 4. Estructura del proyecto

```text
IncluApp/
├── lib/
│   ├── core/
│   │   ├── theme/              # Paleta de colores, tipografía y estilos globales (AppTheme)
│   │   └── utils/              # Utilidades compartidas (AppSnackBar)
│   ├── data/
│   │   └── services/           # Capa de servicios: OCR (ML Kit) y TTS nativo
│   ├── presentation/
│   │   ├── screens/            # Pantallas: CameraScreen, ReaderScreen, HelpScreen
│   │   └── widgets/            # Widgets reutilizables: FeatureCard
│   └── main.dart               # Punto de entrada, inicialización de Hive y tema
├── docs/
│   ├── Sprint_Backlog.md       # Registro de historias de usuario y tareas por sprint
│   ├── Cronograma.md           # Planificación temporal del proyecto
│   ├── Definition_of_Done.md   # Criterios de aceptación y definición de terminado
│   └── Capturas.md             # Evidencias visuales de las pantallas
├── tests/
│   └── Pruebas_Funcionales.md  # Casos de prueba funcional documentados
├── README.md                   # Documentación principal del proyecto
└── .env.example                # Plantilla de variables de entorno (referencia)
```

### Descripción de carpetas principales

| Carpeta | Descripción |
|---|---|
| `lib/core/theme/` | Define `AppTheme`: colores de alto contraste, tamaños de fuente accesibles y estilos de botones. |
| `lib/core/utils/` | Contiene `AppSnackBar`, clase utilitaria para mensajes de error, advertencia y éxito estandarizados. |
| `lib/data/services/` | `OcrService` encapsula Google ML Kit; `TtsService` encapsula el motor de voz nativo. Ambos son reemplazables sin tocar la UI. |
| `lib/presentation/screens/` | Pantallas de la aplicación. `CameraScreen` es la pantalla principal; `ReaderScreen` muestra el texto y controla la lectura; `HelpScreen` contiene la guía de uso. |
| `lib/presentation/widgets/` | Widgets reutilizables independientes de pantalla. |
| `docs/` | Documentación del proceso de desarrollo ágil (backlog, cronograma, DoD, capturas). |
| `tests/` | Documentación de pruebas funcionales manuales. |

---

## 5. Instalación

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado y en el `PATH`.
- Dart ≥ 3.0.0 (incluido con Flutter).
- Android Studio o VS Code con la extensión Flutter.
- Dispositivo Android físico o emulador con API ≥ 21.

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/<usuario>/IncluApp.git
cd IncluApp

# 2. Instalar dependencias
flutter pub get

# 3. Verificar el entorno
flutter doctor
```

### Permisos requeridos en Android

El archivo `android/app/src/main/AndroidManifest.xml` debe declarar:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

### Permisos requeridos en iOS

El archivo `ios/Runner/Info.plist` debe incluir:

```xml
<key>NSCameraUsageDescription</key>
<string>IncluApp necesita acceso a la cámara para capturar texto.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>IncluApp necesita acceso a la galería para seleccionar imágenes con texto.</string>
```

---

## 6. Ejecución en Flutter Web

```bash
flutter run -d chrome
```

> **Limitación importante:** IncluApp está diseñada principalmente para Android e iOS.
> En Flutter Web, las funcionalidades de `google_mlkit_text_recognition` (OCR nativo) y
> `flutter_tts` (síntesis de voz del sistema) tienen soporte limitado o nulo, ya que dependen
> de APIs nativas del dispositivo. La ejecución en web está disponible únicamente para
> visualizar la interfaz de usuario.

---

## 7. Generación de APK

```bash
# APK de depuración (recomendado para pruebas académicas)
flutter build apk --debug

# APK de release (requiere firma con keystore)
flutter build apk --release
```

El archivo generado se ubica en:

```
build/app/outputs/flutter-apk/app-debug.apk
```

Para instalar directamente en un dispositivo conectado por USB:

```bash
flutter install
```

---

## 8. Credenciales de prueba

IncluApp **no requiere registro ni autenticación**. No existe backend, base de datos remota ni sistema de login.

| Componente | Estado |
|---|---|
| Login / Registro | No aplica |
| API Keys externas | No aplica |
| Variables de entorno sensibles | No aplica |
| Cuenta de prueba | No aplica |

> Todo el funcionamiento es local: el OCR y el TTS se ejecutan en el dispositivo.
> No se necesitan credenciales para instalar ni usar la aplicación.

---

## 9. Documentación del proyecto

| Documento | Ubicación | Contenido |
|---|---|---|
| Sprint Backlog | `docs/Sprint_Backlog.md` | Historias de usuario, tareas y estado por sprint |
| Cronograma | `docs/Cronograma.md` | Planificación temporal y hitos del proyecto |
| Definition of Done | `docs/Definition_of_Done.md` | Criterios que debe cumplir cada funcionalidad para considerarse terminada |
| Capturas de pantalla | `docs/Capturas.md` | Evidencias visuales de la interfaz en funcionamiento |
| Pruebas funcionales | `tests/Pruebas_Funcionales.md` | Casos de prueba manuales con resultado esperado y resultado real |
| Indicadores T4 | `T4_Indicadores.md` | Indicadores de avance y métricas del proyecto |
| Hoja de ruta T5 | `T5_Hoja_Ruta.md` | Planificación de entregables y evolución futura del PMV |

---

## 10. Estado del proyecto

| Atributo | Detalle |
|---|---|
| Versión actual | `1.0.0+1` |
| Estado | PMV funcional — en desarrollo activo |
| Plataforma objetivo | Android (primaria) · iOS (secundaria) |
| Costo operativo | USD 0 |
| Cobertura de pruebas | Pruebas funcionales manuales documentadas |

### Funcionalidades implementadas

- [x] Captura de imagen desde cámara y galería
- [x] Extracción de texto mediante OCR local (Google ML Kit)
- [x] Lectura en voz alta con control de velocidad (TTS nativo)
- [x] Historial de lecturas almacenado localmente (Hive)
- [x] Pantalla de ayuda y guía de uso
- [x] Manejo de errores con mensajes visuales (SnackBar, AlertDialog)
- [x] Accesibilidad: alto contraste, tipografía amplia, etiquetas semánticas

### Funcionalidades pendientes

- [ ] Exportar texto extraído como archivo de texto
- [ ] Soporte multiidioma (actualmente solo español)
- [ ] Historial con búsqueda y filtrado

---

## 11. Autores e integrantes

| Nombre | Rol | Contacto |
|---|---|---|
| Juan C. Cevallos | Desarrollador principal / Scrum Master | juanccevallos12@gmail.com |
| _(Pendiente)_ | _(Pendiente)_ | _(Pendiente)_ |

> Proyecto desarrollado como parte de una entrega académica.
> Institución: _(Pendiente — agregar nombre de la universidad o programa)_
> Período: _(Pendiente — agregar ciclo o semestre)_
