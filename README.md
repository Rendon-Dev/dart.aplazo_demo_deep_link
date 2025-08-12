# Aplazo Demo Deep Link

Una aplicación Flutter demo que demuestra el manejo de deep links y apertura de URLs tanto en aplicaciones externas como en WebView.

## 📱 Funcionalidades

### 1. **Apertura de URLs Externas**
- Input con hint "Open app"
- Abre URLs en aplicaciones externas del dispositivo
- Utiliza `url_launcher` para manejar diferentes tipos de URLs

### 2. **WebView Integrado**
- Input con hint "Open webview"
- Abre URLs dentro de la aplicación usando WebView
- Incluye indicador de carga y navegación

### 3. **Manejo de Deep Links**
- Soporte para deep links con esquema `cashi://`
- Procesamiento automático de URLs desde deep links
- Formato soportado: `cashi://deeplink?action=openUrl&url=<URL_A_ABRIR>`

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework principal
- **url_launcher**: Para abrir URLs en aplicaciones externas
- **webview_flutter**: Para mostrar contenido web dentro de la app
- **Method Channels**: Comunicación entre Flutter y código nativo Android

## 🔧 Configuración del Proyecto

### Dependencias
```yaml
dependencies:
  flutter:
    sdk: flutter
  url_launcher: ^6.2.2
  webview_flutter: ^4.4.2
  cupertino_icons: ^1.0.8
```

### AndroidManifest.xml
La aplicación está configurada para recibir deep links con el esquema `cashi://`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="cashi" />
</intent-filter>
```

## 🚀 Cómo Usar

### Instalación
1. Clona el repositorio
2. Ejecuta `flutter pub get` para instalar dependencias
3. Ejecuta `flutter run` para iniciar la aplicación

### Uso de la Interfaz
1. **Open app**: Ingresa una URL y presiona el botón para abrirla externamente
2. **Open webview**: Ingresa una URL y presiona el botón para abrirla en WebView

### Probar Deep Links
Utiliza ADB para enviar deep links a la aplicación:

```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "cashi://deeplink?action=openUrl&url=https://google.com" \
  com.example.aplazo_demo_deep_link
```

## 📋 Estructura del Deep Link

### Formato
```
cashi://deeplink?action=openUrl&url=<URL_DESTINO>
```

### Parámetros
- **scheme**: `cashi` (obligatorio)
- **host**: `deeplink` (obligatorio)
- **action**: `openUrl` (define la acción a realizar)
- **url**: URL de destino que se abrirá

### Ejemplo
```
cashi://deeplink?action=openUrl&url=https://www.aplazo.mx
```

## 🏗️ Arquitectura

### Flutter (Dart)
- **main.dart**: Interfaz principal con inputs y lógica de navegación
- **OpenUrlScreen**: Pantalla principal con formularios
- **WebViewScreen**: Pantalla para mostrar contenido web
- **Method Channel**: Comunicación con código nativo para deep links

### Android (Kotlin)
- **MainActivity.kt**: Manejo nativo de deep links y comunicación con Flutter
- **AndroidManifest.xml**: Configuración de intent filters para deep links

## 🎯 Casos de Uso

1. **Navegación Externa**: Abrir enlaces en el navegador predeterminado o apps específicas
2. **Contenido Integrado**: Mostrar páginas web dentro de la aplicación
3. **Deep Link Processing**: Recibir y procesar enlaces desde otras aplicaciones
4. **URL Sharing**: Facilitar el intercambio de URLs entre aplicaciones

## 🔐 Consideraciones de Seguridad

- Validación de URLs antes de procesarlas
- Manejo de errores para URLs malformadas
- Protección contra deep links maliciosos

## 📱 Compatibilidad

- **Plataforma**: Android (orientado específicamente a Android)
- **Flutter SDK**: ^3.7.2
- **Versión mínima de Android**: API 21 (Android 5.0)

## 🧪 Pruebas

### Casos de Prueba Recomendados
1. URLs válidas (HTTP/HTTPS)
2. URLs malformadas
3. Deep links válidos
4. Deep links con parámetros faltantes
5. Navegación de WebView
6. Manejo de errores de conexión

## 📞 Soporte

Para preguntas o issues relacionados con este proyecto, por favor contacta al equipo de desarrollo de Aplazo.