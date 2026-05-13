# 🐾 CEREFAS - Monitor Ambiental Inteligente para Fauna Silvestre

Este proyecto es una solución integral de **IoT (Internet of Things)** diseñada para la organización **CEREFAS**. Su objetivo es monitorear en tiempo real las condiciones climáticas (temperatura y humedad) de las jaulas de animales en proceso de rehabilitación, asegurando un entorno óptimo para su recuperación.

## 🚀 El Sistema en un Vistazo

El proyecto integra tres pilares tecnológicos:
1.  **Hardware (ESP32 + DHT11):** Captura de datos ambientales y envío mediante protocolo HTTP/REST.
2.  **Backend (Supabase):** Base de Datos como Servicio (BaaS) que almacena el historial y gestiona el tiempo real.
3.  **Frontend (Flutter):** Aplicación móvil multiplataforma que visualiza datos y genera alertas críticas.

## 🏗️ Arquitectura de la Solución

```mermaid
graph LR
  A[ESP32 + Sensor] -- WiFi --> B((Supabase Cloud))
  B -- Stream --> C[App Móvil Flutter]
  C -- Consulta --> B

📂 Estructura del Repositorio
Para facilitar el desarrollo y la colaboración, el código se divide en dos módulos principales:

/flutter_app: Contiene el código fuente de la aplicación móvil desarrollada con Flutter. Incluye la lógica de conexión a Supabase, gestión de estados y diseño de interfaz.

/esp32_hardware: Scripts en MicroPython para la placa ESP32. Incluye el manejo del sensor, la lógica de conexión WiFi y el envío de datos a la nube.

🛠️ Requisitos Rápidos
Hardware: Placa ESP32, Sensor DHT11 o DHT22, cables jumper.

Software: Flutter SDK (>= 3.0), entorno de ejecución MicroPython (Thonny recomendado).

Servicios: Cuenta activa en Supabase.

🔐 Seguridad y Configuración
Este repositorio utiliza una política estricta de seguridad:

Los archivos que contienen credenciales reales (secrets.py en hardware y configuraciones locales en Flutter) están excluidos mediante el archivo .gitignore.

Para configurar el proyecto por primera vez, utiliza los archivos de plantilla: secrets_example.py dentro de la carpeta de hardware.

👥 Equipo
Proyecto desarrollado como parte del ramo de Innovación, enfocado en generar impacto tecnológico real para la organización CEREFAS.
