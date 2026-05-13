# Archivo: main.py
import network
import machine
import dht
import urequests 
import ujson
import time
import secrets

TABLA_NOMBRE = "sensor_data" 
# Ahora la URL se arma usando el archivo secrets
URL_DESTINO = "{}/rest/v1/{}".format(secrets.SUPABASE_URL, TABLA_NOMBRE)

# Configurar el sensor
sensor = dht.DHT11(machine.Pin(4)) 

def conectar_wifi(): 
    wlan = network.WLAN(network.STA_IF) 
    wlan.active(True) 
    if not wlan.isconnected(): 
        print("Conectando a Wi-Fi...") 
        # Usamos las credenciales protegidas
        wlan.connect(secrets.WIFI_SSID, secrets.WIFI_PASSWORD) 
        while not wlan.isconnected(): 
            print(".", end="") 
            time.sleep(0.5) 
    print("\n¡Conectado a Wi-Fi! IP:", wlan.ifconfig()[0])

def enviar_a_supabase(temp, hum): 
    datos = { 
        "temperature": temp, 
        "humidity": hum 
    } 
    
    # Usamos la API Key protegida
    headers = {
        "apikey": secrets.SUPABASE_KEY,
        "Authorization": "Bearer {}".format(secrets.SUPABASE_KEY),
        "Content-Type": "application/json",
        "Prefer": "return=minimal"
    }
    
    datos_json = ujson.dumps(datos) 
    
    try: 
        respuesta = urequests.post(URL_DESTINO, data=datos_json, headers=headers) 
        if respuesta.status_code == 201 or respuesta.status_code == 200:
            print("¡Éxito! Dato guardado en la base de datos de Brasil.") 
        else:
            print("Error Supabase:", respuesta.status_code, respuesta.text)
        respuesta.close() 
    except Exception as e: 
        print("Error de conexión:", e) 

# --- Ejecución Principal ---
conectar_wifi() 

while True: 
    try: 
        sensor.measure() 
        t = sensor.temperature() 
        h = sensor.humidity() 
        
        print("Temperatura: {}°C | Humedad: {}%".format(t, h))
        enviar_a_supabase(t, h) 
        
    except OSError as e: 
        print("Error al leer el sensor. Revisa las conexiones.") 
        
    time.sleep(5)
