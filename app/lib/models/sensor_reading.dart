/// Modelo de datos para una lectura de sensor ambiental.
///
/// Mapea directamente a la tabla `sensor_data` de Supabase.
class SensorReading {
  /// Identificador único de la lectura.
  final int id;

  /// Fecha y hora en que se registró la lectura.
  final DateTime createdAt;

  /// Temperatura en grados Celsius.
  final double temperature;

  /// Humedad relativa en porcentaje (0-100).
  final double humidity;

  const SensorReading({
    required this.id,
    required this.createdAt,
    required this.temperature,
    required this.humidity,
  });

  /// Crea una instancia a partir de un mapa JSON (respuesta de Supabase).
  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
    );
  }

  /// Convierte la instancia a un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
    };
  }

  /// Indica si la temperatura está por encima del umbral de alerta (30°C).
  bool get isTemperatureAlert => temperature > 30.0;

  /// Indica si la humedad está por encima del umbral de alerta (80%).
  bool get isHumidityAlert => humidity > 80.0;

  @override
  String toString() =>
      'SensorReading(id: $id, temp: $temperature°C, hum: $humidity%, at: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorReading &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
