# IncluApp

Aplicación móvil de accesibilidad educativa con reconocimiento óptico de caracteres (OCR) local y síntesis de voz (TTS) nativa, desarrollada con Flutter y Dart.

**Repositorio público:** https://github.com/StevenAJ23/IncluApp

---

## 1. Descripción general

**IncluApp** es un Producto Mínimo Viable (PMV) de accesibilidad orientado a estudiantes con dislexia o baja visión. El caso de estudio se contextualiza en el Colegio Fe y Alegría, institución educativa que atiende a poblaciones con necesidades especiales de aprendizaje.

La aplicación permite fotografiar texto impreso, como libros, pizarras, hojas de trabajo o apuntes, y escucharlo en voz alta de manera inmediata. Todo el procesamiento ocurre en el propio dispositivo: no se transmite información a servidores externos, no se requiere conexión a internet durante el uso principal y el costo operativo del PMV es **USD 0**.

IncluApp prioriza la accesibilidad mediante una interfaz de alto contraste, botones grandes, tipografía legible, mensajes visuales claros y lectura por voz del texto reconocido.

---

## 2. Objetivo de la aplicación

Reducir la barrera de acceso al contenido escrito para estudiantes con dislexia o baja visión mediante una herramienta móvil que:

- Extrae texto de imágenes usando OCR local con Google ML Kit.
- Lee el texto extraído en voz alta con el motor de síntesis de voz nativo del dispositivo.
- Ofrece una interfaz accesible con alto contraste, tipografía clara y controles táctiles amplios.
- Permite capturar texto desde cámara o galería.
- Guarda un historial local de lecturas mediante Hive.
- Protege la privacidad del contenido académico al no requerir backend ni servicios externos.

---

## 3. Stack tecnológico

| Tecnología | Versión / referencia | Rol en el proyecto |
|---|---|---|
| Flutter | >= 3.0 | Framework de interfaz multiplataforma para Android, iOS y Web |
| Dart | >= 3.0.0 < 4.0.0 | Lenguaje principal de programación |
| google_mlkit_text_recognition | ^0.13.0 | OCR local para extracción de texto sin conexión |
| flutter_tts | ^4.0.2 | Síntesis de voz nativa del dispositivo |
| hive | ^2.2.3 | Base de datos local para historial de lecturas |
| hive_flutter | ^1.1.0 | Integración de Hive con Flutter |
| image_picker | ^1.1.2 | Selección de imágenes desde cámara o galería |
| camera | ^0.11.0+2 | Acceso directo a la cámara del dispositivo |
| permission_handler | ^11.3.1 | Gestión de permisos en tiempo de ejecución |
| path_provider | ^2.1.3 | Acceso a rutas del sistema de archivos local |

**Nota:** IncluApp no utiliza backend, Firebase, AWS, Azure, APIs de pago ni servicios externos. El diseño sigue el principio de procesamiento local, ya que el OCR, el TTS y el historial se ejecutan en el dispositivo.

---

## 4. Estructura del proyecto

El proyecto **IncluApp** está organizado siguiendo una estructura por capas propia de una aplicación Flutter. Esta organización permite separar la interfaz, los servicios, la configuración visual y la documentación del proyecto.

```text
IncluApp/
├── android/                    # Configuración nativa para Android
├── ios/                        # Configuración nativa para iOS
├── web/                        # Soporte para ejecución web de la interfaz
├── lib/
│   ├── core/
│   │   ├── theme/              # Tema visual, colores, tipografía y estilos globales
│   │   └── utils/              # Utilidades compartidas, mensajes y helpers
│   ├── data/
│   │   └── services/           # Servicios de OCR, TTS y lógica relacionada
│   ├── presentation/
│   │   ├── screens/            # Pantallas principales de la aplicación
│   │   └── widgets/            # Componentes reutilizables de interfaz
│   └── main.dart               # Punto de entrada de la aplicación
├── docs/
│   ├── Sprint_Backlog.md       # Planificación de sprints e historias de usuario
│   ├── Cronograma.md           # Cronograma de trabajo del proyecto
│   ├── Definition_of_Done.md   # Criterios para considerar una función terminada
│   ├── Capturas.md             # Evidencias visuales de funcionamiento
│   └── capturas/               # Imágenes de evidencia de la app
├── tests/
│   └── Pruebas_Funcionales.md  # Registro de pruebas funcionales manuales
├── README.md                   # Documentación principal del proyecto
├── .env.example                # Plantilla de variables de entorno sin datos reales
├── pubspec.yaml                # Dependencias y configuración Flutter
└── pubspec.lock                # Versiones exactas de dependencias instaladas
```

### Descripción de carpetas principales

| Carpeta | Descripción |
|---|---|
| `android/` | Contiene la configuración nativa necesaria para compilar e instalar la aplicación en dispositivos Android. |
| `ios/` | Contiene la configuración nativa para una posible ejecución en dispositivos iOS. |
| `web/` | Permite ejecutar la interfaz de la aplicación en navegador mediante Flutter Web. |
| `lib/` | Contiene el código fuente principal de la aplicación Flutter. |
| `lib/core/theme/` | Define la apariencia visual de la aplicación, como colores, estilos, botones y tipografía accesible. |
| `lib/core/utils/` | Contiene utilidades compartidas, como mensajes visuales o funciones auxiliares usadas en varias pantallas. |
| `lib/data/services/` | Agrupa los servicios principales de la aplicación, como reconocimiento OCR y lectura por voz. |
| `lib/presentation/screens/` | Contiene las pantallas de la aplicación, por ejemplo la pantalla principal, ayuda, captura y lectura. |
| `lib/presentation/widgets/` | Contiene widgets reutilizables para mantener el código más ordenado. |
| `docs/` | Contiene la documentación del proyecto, evidencias, cronograma, backlog y Definition of Done. |
| `docs/capturas/` | Guarda las capturas de pantalla que evidencian el funcionamiento de la aplicación. |
| `tests/` | Contiene la documentación de pruebas funcionales manuales realizadas al MVP. |

**Nota:** En proyectos Flutter, la carpeta `lib/` cumple la función equivalente a `src/` en otros tipos de proyectos, ya que contiene el código fuente principal de la aplicación.

---

## 5. Instalación

### Requisitos previos

Para ejecutar el proyecto se requiere:

- Flutter SDK instalado y agregado al PATH.
- Dart incluido con Flutter.
- Android Studio o Visual Studio Code con la extensión de Flutter.
- Dispositivo Android físico o emulador.
- Git instalado.

### Pasos de instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/StevenAJ23/IncluApp.git

# 2. Entrar al proyecto
cd IncluApp

# 3. Instalar dependencias
flutter pub get

# 4. Verificar el entorno
flutter doctor
```

### Permisos requeridos en Android

El archivo `android/app/src/main/AndroidManifest.xml` debe declarar permisos para cámara y acceso a imágenes, según la versión de Android utilizada:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

### Permisos requeridos en iOS

El archivo `ios/Runner/Info.plist` debe incluir descripciones de uso para cámara y galería:

```xml
<key>NSCameraUsageDescription</key>
<string>IncluApp necesita acceso a la cámara para capturar texto.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>IncluApp necesita acceso a la galería para seleccionar imágenes con texto.</string>
```

---

## 6. Ejecución en Flutter Web

Para ejecutar la interfaz en navegador:

```bash
flutter run -d chrome
```

**Limitación importante:** IncluApp está diseñada principalmente para Android. En Flutter Web, las funcionalidades de OCR con Google ML Kit y TTS nativo pueden tener soporte limitado, ya que dependen de APIs nativas del dispositivo. Por ello, la ejecución web se utiliza principalmente para visualizar la interfaz.

---

## 7. Generación de APK

Para generar una APK de depuración:

```bash
flutter build apk --debug
```

El archivo generado se encuentra en:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Para instalar directamente en un dispositivo Android conectado por USB:

```bash
flutter install
```

También puede instalarse manualmente copiando el archivo `app-debug.apk` al celular y habilitando la instalación desde fuentes permitidas.

---

## 8. Credenciales de prueba

IncluApp no requiere registro, inicio de sesión ni credenciales de prueba.

| Componente | Estado |
|---|---|
| Login / Registro | No aplica |
| API Keys externas | No aplica |
| Variables de entorno sensibles | No aplica |
| Cuenta de prueba | No aplica |
| Backend | No aplica |

Todo el funcionamiento es local. El OCR, el TTS y el historial se ejecutan directamente en el dispositivo, por lo que no se necesitan credenciales para instalar ni utilizar la aplicación.

---

## 9. Documentación del proyecto

| Documento | Ubicación | Contenido |
|---|---|---|
| Sprint Backlog | `docs/Sprint_Backlog.md` | Historias de usuario, tareas, responsables, fechas y estado por sprint. |
| Cronograma | `docs/Cronograma.md` | Planificación temporal del proyecto desde la semana 7 hasta la semana 11. |
| Definition of Done | `docs/Definition_of_Done.md` | Criterios para considerar una funcionalidad terminada. |
| Capturas de pantalla | `docs/Capturas.md` | Evidencias visuales de la aplicación funcionando. |
| Pruebas funcionales | `tests/Pruebas_Funcionales.md` | Casos de prueba manuales con resultado esperado y resultado real. |

La evidencia principal de funcionamiento se encuentra en:

```text
docs/Capturas.md
```

---

## 10. Estado del proyecto

| Atributo | Detalle |
|---|---|
| Versión actual | 1.0.0+1 |
| Estado | PMV funcional |
| Plataforma principal | Android |
| Plataforma secundaria | iOS / Web para visualización de interfaz |
| Costo operativo | USD 0 |
| Tipo de pruebas | Pruebas funcionales manuales |
| Evidencia de funcionamiento | APK instalada y capturas documentadas |

### Funcionalidades implementadas

- Captura de imagen desde cámara.
- Selección de imagen desde galería.
- Extracción de texto mediante OCR local con Google ML Kit.
- Lectura en voz alta con Flutter TTS.
- Controles de lectura.
- Velocidad de voz ajustable.
- Historial local de lecturas con Hive.
- Pantalla de ayuda y guía de uso.
- Mensajes visuales de carga, éxito y error.
- Diseño accesible con alto contraste, botones grandes y tipografía legible.
- APK generada e instalada en dispositivo Android.
- Evidencias visuales registradas en `docs/Capturas.md`.

### Funcionalidades pendientes

- Exportar el texto extraído como archivo de texto.
- Agregar soporte multiidioma.
- Mejorar el historial con búsqueda y filtrado.
- Optimizar la experiencia de lectura para más tipos de documentos.
- Preparar una versión release firmada para distribución externa.

---

## 11. Autores e integrantes

| Nombre | Rol Scrum | Responsabilidad técnica |
|---|---|---|
| Juan C. Cevallos | Scrum Master / Developer | Organización del backlog, documentación, estructura del proyecto, seguimiento y entrega. |
| Kevin Daniel Cepeda Lema | Product Owner | Validación de funcionalidades, necesidades del usuario, priorización y criterios de aceptación. |
| Steven Ariel Rosero | Developer | Captura de imagen, permisos, OCR local y procesamiento de texto. |
| Victoria Yulieth Galarza Taco | QA / Developer | Pruebas funcionales, accesibilidad, revisión de errores y evidencias. |

Proyecto desarrollado como parte de una entrega académica.

**Institución:** Pontificia Universidad Católica del Ecuador  
**Carrera:** Ingeniería en Sistemas  
**Materia:** Emprendimiento Tecnológico  
**Proyecto:** IncluApp — PMV de accesibilidad educativa  

---

## Definition of Done resumida

Una funcionalidad de IncluApp se considera terminada cuando cumple con los siguientes criterios:

- Está implementada en el código fuente.
- Funciona en ejecución local sin errores críticos.
- Presenta una interfaz accesible y comprensible para el usuario.
- Fue probada manualmente.
- El cambio fue subido al repositorio GitHub con un commit descriptivo.
- La documentación fue actualizada si corresponde.
- Existe evidencia mediante captura de pantalla o prueba funcional.
- Cumple con el objetivo del MVP: convertir texto impreso en audio.

---

## Observaciones finales

IncluApp es una solución móvil enfocada en accesibilidad educativa. Su principal valor está en permitir que estudiantes con dislexia o baja visión puedan convertir texto impreso en audio de forma rápida, privada y sin depender de servicios externos.

Al tratarse de una aplicación móvil Flutter, la evidencia principal de funcionamiento se presenta mediante APK instalada en Android y capturas documentadas en `docs/Capturas.md`. Flutter Web se utiliza únicamente como apoyo para visualizar la interfaz, pero no reemplaza la prueba en dispositivo móvil.
