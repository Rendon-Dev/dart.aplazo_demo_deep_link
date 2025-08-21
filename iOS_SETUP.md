# Configuración iOS - Aplazo Demo Deep Link

## ✅ Configuración Completada

Tu proyecto Flutter ya está configurado para iOS con soporte completo para deep links.

## 📱 Esquemas de URL Configurados

La app está configurada para responder a los siguientes esquemas de URL:

- `cashi://` - Esquema principal para deep links
- `aplazodemo://` - Esquema alternativo

## 🔧 Configuración Técnica

### Info.plist
Se ha configurado el `ios/Runner/Info.plist` con:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.example.aplazoDemoDeepLink</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>cashi</string>
            <string>aplazodemo</string>
        </array>
    </dict>
</array>
```

### AppDelegate.swift
Se ha modificado `ios/Runner/AppDelegate.swift` para manejar deep links tanto al abrir la app como cuando ya está ejecutándose.

## 🧪 Cómo Probar Deep Links

### 1. En el Simulador de iOS
```bash
# Abrir la app en el simulador
flutter run

# En otra terminal, ejecutar:
xcrun simctl openurl booted "cashi://deeplink?action=openUrl&url=https://example.com&param1=value1"
```

### 2. En un Dispositivo Físico
1. Instala la app en tu dispositivo iOS
2. Abre Safari y navega a: `cashi://deeplink?action=openUrl&url=https://example.com&param1=value1`
3. La app se abrirá automáticamente

### 3. Desde otra App
```swift
// En otra app iOS
if let url = URL(string: "cashi://deeplink?action=openUrl&url=https://example.com") {
    UIApplication.shared.open(url)
}
```

## 📋 Ejemplos de Deep Links

### Ejemplo Básico
```
cashi://deeplink
```

### Con Parámetros
```
cashi://deeplink?action=openUrl&url=https://example.com&param1=value1&param2=value2
```

### Login de Usuario
```
cashi://deeplink?user=john&token=abc123&redirect=home
```

### Detalles de Producto
```
cashi://deeplink?product=shirt&price=29.99&color=blue&size=M
```

## 🚀 Compilación y Despliegue

### Compilar para Desarrollo
```bash
flutter build ios --debug
```

### Compilar para Producción
```bash
flutter build ios --release
```

### Abrir en Xcode
```bash
open ios/Runner.xcworkspace
```

## 📱 Características de la App

1. **Detección de Deep Links**: La app detecta automáticamente cuando se abre con un deep link
2. **Parsing de Parámetros**: Extrae y muestra todos los parámetros de la URL
3. **WebView Integrado**: Permite abrir URLs dentro de la app
4. **Navegador Externo**: Opción para abrir URLs en Safari
5. **Manejo de Errores**: Gestión robusta de errores de conexión

## 🔍 Debugging

### Logs de Flutter
```bash
flutter logs
```

### Logs de Xcode
1. Abre Xcode
2. Window > Devices and Simulators
3. Selecciona tu dispositivo
4. View Device Logs

## 📦 Dependencias

Las siguientes dependencias están configuradas:
- `url_launcher`: Para abrir URLs en navegador externo
- `webview_flutter`: Para mostrar contenido web dentro de la app

## 🎯 Próximos Pasos

1. **Testing**: Prueba los deep links en diferentes escenarios
2. **Personalización**: Modifica los esquemas de URL según tus necesidades
3. **Producción**: Configura el certificado de distribución para App Store
4. **Analytics**: Integra analytics para rastrear el uso de deep links

## ❓ Solución de Problemas

### La app no responde a deep links
1. Verifica que el esquema esté correctamente configurado en `Info.plist`
2. Asegúrate de que la app esté instalada en el dispositivo
3. Reinicia la app después de cambios en la configuración

### Errores de compilación
1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Abre el proyecto en Xcode y verifica la configuración

### Deep links no funcionan en dispositivo físico
1. Verifica que el dispositivo esté conectado correctamente
2. Asegúrate de que la app esté firmada correctamente
3. Prueba con diferentes navegadores (Safari, Chrome)

---

¡Tu app de deep links para iOS está lista para usar! 🎉
