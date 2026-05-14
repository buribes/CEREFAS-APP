# 🐾 CEREFAS - Aplicación Móvil (Frontend)

Esta es la aplicación móvil multiplataforma diseñada para la organización **CEREFAS**. Permite a los rescatistas y especialistas monitorear de forma remota y en tiempo real el bienestar de los animales.

## 📱 Funcionalidades Principales

- **Monitoreo en Tiempo Real:** Visualización instantánea de temperatura y humedad.
- **Sincronización:** Actualización automática de datos cada 5 segundos (sincronizado con el hardware).
- **Sistema de Alertas:** Indicadores visuales críticos (Temperatura > 30°C o Humedad > 80%).
- **Historial:** Acceso rápido a las últimas 20 mediciones almacenadas en la nube.
- **Interfaz Moderna:** Basada en Material Design 3 para una experiencia de usuario fluida.

## 🛠️ Tecnologías

- **Framework:** Flutter (Dart)
- **Backend:** Supabase (PostgreSQL + Realtime)
- **Arquitectura:** Gestión de estado mediante Provider.

## 📂 Estructura del Proyecto (`lib/`)

```text
├── config/
│   └── supabase_config.dart   ← Configuración de API Keys
├── models/
│   └── sensor_reading.dart    ← Mapeo de datos de la base de datos
├── services/
│   └── sensor_service.dart    ← Lógica de peticiones a Supabase
├── screens/
│   └── home_screen.dart       ← Interfaz de usuario principal
├── widgets/
│   ├── reading_card.dart      ← Componente de visualización de sensores
│   └── history_list.dart      ← Componente de tabla de historial
└── main.dart                  ← Punto de entrada de la app
```

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
