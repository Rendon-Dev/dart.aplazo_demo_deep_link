# Configuración Firebase App Distribution

## 🚀 Configuración Rápida para QA

Firebase App Distribution es la opción más práctica para tu app dummy. Es **gratuito** y muy fácil de configurar.

---

## 📋 Pasos de Configuración

### 1. Crear Proyecto Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Clic en "Crear proyecto"
3. Nombre: `aplazo-demo-deep-link`
4. Seguir los pasos de configuración

### 2. Configurar Flutter con Firebase

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login a Firebase
firebase login

# Inicializar Firebase en el proyecto
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Agregar Dependencias

```yaml
# En pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_app_check: ^0.2.1+14
```

### 4. Configurar iOS

```bash
# Instalar pods
cd ios
pod install
cd ..
```

### 5. Configurar App Distribution

1. En Firebase Console > App Distribution
2. Clic en "Get started"
3. Subir tu primer build

---

## 🔧 Configuración Detallada

### Paso 1: Firebase CLI

```bash
# Instalar Firebase CLI
curl -sL https://firebase.tools | bash

# Login
firebase login

# Verificar instalación
firebase --version
```

### Paso 2: FlutterFire CLI

```bash
# Instalar FlutterFire
dart pub global activate flutterfire_cli

# Configurar proyecto
flutterfire configure
```

### Paso 3: Configurar iOS

```bash
# Navegar a carpeta iOS
cd ios

# Instalar pods
pod install

# Volver al directorio raíz
cd ..
```

### Paso 4: Modificar main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## 📱 Subir Build a Firebase

### Opción 1: Firebase CLI

```bash
# Compilar para iOS
flutter build ios --release

# Subir a Firebase
firebase appdistribution:distribute "build/ios/iphoneos/Runner.ipa" \
  --app FIREBASE_APP_ID \
  --release-notes "Versión 1.0 - Deep links funcionando" \
  --groups "qa-team"
```

### Opción 2: Firebase Console

1. Ir a Firebase Console > App Distribution
2. Clic en "Upload release"
3. Seleccionar archivo .ipa
4. Agregar notas de release
5. Seleccionar grupo de testers

---

## 👥 Configurar Equipo de QA

### 1. Crear Grupo de Testers

1. En Firebase Console > App Distribution
2. Clic en "Testers & groups"
3. Clic en "Create group"
4. Nombre: "QA Team"

### 2. Agregar Testers

1. Clic en el grupo creado
2. Clic en "Add testers"
3. Agregar emails del equipo de QA

### 3. Invitar Testers

1. Firebase enviará emails automáticamente
2. Los testers deben:
   - Instalar Firebase App Distribution
   - Aceptar la invitación
   - Instalar la app

---

## 🧪 Proceso de Testing

### Para el Equipo de QA:

1. **Recibir invitación** por email
2. **Instalar Firebase App Distribution** desde App Store
3. **Aceptar invitación** en la app
4. **Instalar la app** de deep links
5. **Probar funcionalidades** según casos de prueba

### Casos de Prueba:

```
# Deep links básicos
cashi://deeplink

# Con parámetros
cashi://deeplink?action=openUrl&url=https://example.com

# Login
cashi://deeplink?user=test&token=abc123
```

---

## 🔄 Workflow de Distribución

### Para cada nueva versión:

1. **Desarrollar cambios**
2. **Compilar app**:
   ```bash
   flutter build ios --release
   ```
3. **Subir a Firebase**:
   ```bash
   firebase appdistribution:distribute "build/ios/iphoneos/Runner.ipa" \
     --app FIREBASE_APP_ID \
     --release-notes "Nueva versión con mejoras" \
     --groups "qa-team"
   ```
4. **QA recibe notificación** automática
5. **QA instala y prueba**

---

## 📊 Ventajas de Firebase App Distribution

### ✅ Gratuito
- Sin costos mensuales
- Sin límite de builds
- Sin límite de testers

### ✅ Fácil de usar
- Interfaz web simple
- Notificaciones automáticas
- Instalación directa

### ✅ Integración con Flutter
- CLI nativo
- Configuración automática
- Builds optimizados

### ✅ Analytics
- Métricas de instalación
- Crash reporting
- Performance monitoring

---

## ❓ Solución de Problemas

### Error de Code Signing:
```bash
# Verificar configuración en Xcode
open ios/Runner.xcworkspace
# Ir a Signing & Capabilities
# Asegurar que "Automatically manage signing" esté marcado
```

### Build falla:
```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
flutter build ios --release
```

### Testers no reciben invitación:
1. Verificar email en Firebase Console
2. Reenviar invitación manualmente
3. Verificar spam folder

---

## 🎯 Próximos Pasos

1. **Configurar Firebase** siguiendo esta guía
2. **Probar con un dispositivo** primero
3. **Agregar equipo de QA** al grupo
4. **Distribuir primera versión**
5. **Recopilar feedback** y iterar

---

¡Con Firebase App Distribution tendrás una solución profesional y gratuita para distribuir tu app al equipo de QA! 🚀
