# 🐾 CEREFAS - Monitor Ambiental

Aplicación móvil desarrollada con Flutter para monitorear las condiciones ambientales de jaulas de animales en rehabilitación de la organización **CEREFAS**.

## ¿Qué hace la app?

- Muestra en tiempo real la temperatura y humedad de las jaulas
- Actualización automática cada 10 segundos
- Alertas visuales cuando la temperatura supera 30°C o la humedad supera 80%
- Historial de las últimas 20 mediciones con fecha y hora
- Diseño Material Design 3

## Tecnologías utilizadas

- **Flutter** — Framework de desarrollo móvil
- **Supabase** — Base de datos en la nube
- **Sensor DHT11 + ESP32** — Hardware de medición
- **Provider** — Gestión de estado

## Estructura del proyecto
lib/
├── config/
│   └── supabase_config.dart   ← Credenciales de Supabase (ver configuración)
├── models/
│   └── sensor_reading.dart    ← Modelo de datos
├── services/
│   └── sensor_service.dart    ← Conexión a Supabase
├── screens/
│   └── home_screen.dart       ← Pantalla principal
├── widgets/
│   ├── reading_card.dart      ← Tarjeta de temperatura/humedad
│   └── history_list.dart      ← Lista de historial
└── main.dart

## ⚙️ Configuración antes de correr

### 1. Clonar el repositorio
```bash
git clone https://github.com/buribes/CEREFAS-APP.git
cd CEREFAS-APP
```

### 2. Agregar las credenciales de Supabase

Abre el archivo `lib/config/supabase_config.dart` y reemplaza los placeholders con las credenciales reales del proyecto (pedírselas al equipo):

```dart
static const String supabaseUrl = 'TU_SUPABASE_URL';
static const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';
```

> ⚠️ **Importante:** Antes de hacer `git push`, vuelve a dejar los placeholders `TU_SUPABASE_URL` y `TU_SUPABASE_ANON_KEY` en ese archivo. Nunca subas las credenciales reales al repositorio.

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Correr la app
```bash
# En emulador Android o dispositivo conectado
flutter run

# En Chrome (para pruebas rápidas)
flutter run -d chrome
```

## 🔮 Funcionalidades futuras

- Login y autenticación de usuarios
- Soporte para múltiples jaulas
- Notificaciones push cuando hay alertas
- Gráficos históricos de temperatura y humedad
- Integración con cámara ESP32-CAM para vigilancia visual

## Equipo
Proyecto desarrollado para el ramo de Innovación en apoyo a la organización CEREFAS.