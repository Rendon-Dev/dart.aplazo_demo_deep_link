# Guía de Distribución para QA - Aplazo Demo Deep Link

## 🎯 Opciones de Distribución

### Para tu caso (app dummy para pruebas), tienes estas opciones:

1. **Distribución Ad Hoc** ⭐ (Recomendado)
2. **TestFlight** (Si tienes cuenta de desarrollador)
3. **Instalación Directa** (Para pruebas inmediatas)

---

## 🚀 Opción 1: Distribución Ad Hoc (Recomendado)

### Ventajas:
- ✅ No requiere revisión de Apple
- ✅ Instalación directa en dispositivos
- ✅ Funciona con cuenta gratuita de Apple ID
- ✅ Ideal para equipos pequeños de QA

### Pasos:

#### 1. Configurar Code Signing en Xcode
```bash
# Abrir el proyecto en Xcode
open ios/Runner.xcworkspace
```

#### 2. En Xcode:
1. Seleccionar el proyecto "Runner"
2. Seleccionar el target "Runner"
3. Ir a "Signing & Capabilities"
4. Marcar "Automatically manage signing"
5. Seleccionar tu equipo de desarrollo
6. Cambiar Bundle Identifier a algo único (ej: `com.tuempresa.aplazodemo`)

#### 3. Registrar Dispositivos de QA
1. En Xcode: Window > Devices and Simulators
2. Conectar dispositivos de QA
3. Copiar UDID de cada dispositivo
4. Agregar UDIDs en Apple Developer Portal

#### 4. Crear Provisioning Profile Ad Hoc
1. Ir a [Apple Developer Portal](https://developer.apple.com)
2. Certificates, Identifiers & Profiles
3. Profiles > + > Ad Hoc
4. Seleccionar App ID y dispositivos
5. Descargar y instalar el profile

#### 5. Compilar y Distribuir
```bash
# Compilar para release
flutter build ios --release

# El archivo .ipa estará en:
# build/ios/iphoneos/Runner.ipa
```

#### 6. Distribuir a QA
- **Opción A**: Usar servicios como Diawi, TestFlight, o Firebase App Distribution
- **Opción B**: Compartir el .ipa directamente (requiere instalación manual)

---

## 📱 Opción 2: TestFlight (Si tienes cuenta de desarrollador)

### Ventajas:
- ✅ Distribución oficial de Apple
- ✅ Fácil instalación para QA
- ✅ Actualizaciones automáticas
- ✅ Analytics integrados

### Pasos:
1. Subir build a App Store Connect
2. Configurar TestFlight
3. Invitar equipo de QA
4. QA recibe email con link de instalación

---

## 🔧 Opción 3: Instalación Directa (Para pruebas rápidas)

### Para pruebas inmediatas sin distribución:

```bash
# Compilar y instalar directamente
flutter run --release

# O usar Xcode
open ios/Runner.xcworkspace
# Luego Product > Archive
```

---

## 📋 Checklist de Preparación

### Antes de distribuir:
- [ ] App compila sin errores
- [ ] Deep links funcionan correctamente
- [ ] Bundle ID es único
- [ ] Dispositivos de QA registrados
- [ ] Provisioning profile creado
- [ ] App firmada correctamente

### Para QA:
- [ ] Dispositivos iOS compatibles (iOS 12+)
- [ ] Conexión a internet para deep links
- [ ] Instrucciones de instalación
- [ ] Casos de prueba documentados

---

## 🛠️ Configuración Rápida (Recomendado para tu caso)

### 1. Configurar Xcode
```bash
open ios/Runner.xcworkspace
```

### 2. Cambiar Bundle ID
En Xcode:
- Project > Runner > Bundle Identifier
- Cambiar a: `com.tuempresa.aplazodemo` (o algo único)

### 3. Configurar Signing
- Signing & Capabilities
- Marcar "Automatically manage signing"
- Seleccionar tu Apple ID

### 4. Compilar
```bash
flutter build ios --release
```

### 5. Distribuir
- Usar servicios como:
  - **Diawi** (gratuito para builds pequeños)
  - **Firebase App Distribution** (gratuito)
  - **TestFlight** (si tienes cuenta de desarrollador)

---

## 📱 Servicios de Distribución Recomendados

### Gratuitos:
1. **Firebase App Distribution**
   - Fácil de configurar
   - Integración con Flutter
   - Notificaciones automáticas

2. **Diawi**
   - Interfaz web simple
   - QR codes para instalación
   - Gratuito para uso básico

### De Pago:
1. **TestFlight** (incluido con cuenta de desarrollador)
2. **AppCenter** (Microsoft)
3. **HockeyApp**

---

## 🧪 Casos de Prueba para QA

### Deep Links a Probar:
```
# Básico
cashi://deeplink

# Con parámetros
cashi://deeplink?action=openUrl&url=https://example.com&param1=value1

# Login
cashi://deeplink?user=test&token=abc123

# Producto
cashi://deeplink?product=shirt&price=29.99
```

### Funcionalidades a Verificar:
- [ ] App se abre con deep links
- [ ] Parámetros se parsean correctamente
- [ ] WebView funciona
- [ ] Navegador externo funciona
- [ ] Manejo de errores
- [ ] Diferentes esquemas de URL

---

## ❓ Solución de Problemas

### Error de Code Signing:
```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
flutter build ios --release
```

### App no se instala:
1. Verificar UDID del dispositivo
2. Asegurar que esté en el provisioning profile
3. Verificar que el dispositivo confíe en el certificado

### Deep links no funcionan:
1. Verificar esquemas en Info.plist
2. Reiniciar app después de instalación
3. Probar con diferentes navegadores

---

## 🎯 Recomendación Final

Para tu caso (app dummy para QA), te recomiendo:

1. **Usar distribución Ad Hoc** con Firebase App Distribution
2. **Configurar code signing** en Xcode
3. **Registrar dispositivos** de QA
4. **Distribuir** via Firebase o Diawi

Esto te dará la flexibilidad que necesitas sin los costos de TestFlight.

---

¿Necesitas ayuda con algún paso específico? 🚀
