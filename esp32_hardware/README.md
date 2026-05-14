# 🛠️ CEREFAS - Módulo de Hardware (ESP32)

Este directorio contiene el firmware y la configuración necesaria para el nodo sensor del sistema CEREFAS. La placa **ESP32** se encarga de recolectar datos climáticos y transmitirlos de forma segura a la base de datos en la nube.

## 🔌 Componentes Requeridos

* **Microcontrolador:** ESP32 (DevKit V1 o similar).
* **Sensor:** DHT11 o DHT22 (Temperatura y Humedad).
* **Conectividad:** Cables jumper (hembra-hembra).
* **Alimentación:** Conexión USB o fuente externa de 5V.

## 📑 Esquema de Conexión (Pinout)

Para el correcto funcionamiento del código predeterminado, realiza las siguientes conexiones:

| Pin Sensor DHT | Pin ESP32 | Descripción |
| :--- | :--- | :--- |
| **VCC** | 3.3V | Alimentación de voltaje |
| **GND** | GND.1 | Tierra |
| **DATA/SDA** | GPIO 4 | Envío de datos digitales |

> 💡 *Nota: Si utilizas un pin diferente al GPIO 4, asegúrate de actualizar la variable `pinDHT` en tu archivo `main.py`.*

## 💻 Configuración del Software

1.  **Entorno:** Se recomienda utilizar **Thonny IDE** para cargar los scripts.
2.  **Firmware:** Asegúrate de tener instalado el intérprete de **MicroPython** en tu placa ESP32.
3.  **Librerías:** El código requiere la librería estándar de `dht` y `network` incluidas en MicroPython.

## 🔐 Configuración de Seguridad (Importante)

Para proteger tus credenciales, este proyecto separa la lógica de las claves de acceso. Sigue estos pasos para configurar tu dispositivo:

1.  Localiza el archivo **`secrets_example.py`** en esta carpeta.
2.  Crea una copia del archivo y cámbiale el nombre a **`secrets.py`**.
3.  Edita `secrets.py` con tus credenciales reales:
    * `WIFI_SSID`: Nombre de tu red.
    * `WIFI_PASSWORD`: Contraseña de WiFi.
    * `SUPABASE_URL` y `SUPABASE_KEY`: Credenciales de tu proyecto en Supabase.

> ⚠️ *El archivo `secrets.py` está configurado en el `.gitignore` para que nunca se suba al repositorio público por seguridad.*

## 🚀 Ejecución

Una vez configuradas tus claves en `secrets.py`, carga tanto el archivo `main.py` como el `secrets.py` a la memoria interna de la ESP32. Al reiniciar la placa, esta comenzará a transmitir datos automáticamente cada 5 segundos hacia Supabase.

## 👥 Equipo
Proyecto desarrollado por alumnos de la **Universidad San Sebastián** en apoyo a la organización **CEREFAS**.
