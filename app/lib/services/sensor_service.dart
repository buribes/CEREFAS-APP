import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/sensor_reading.dart';

/// Servicio independiente para interactuar con la tabla `sensor_data`
/// de Supabase.
///
/// Diseñado para ser inyectable y desacoplado de la UI. Puede ser
/// proporcionado a través de Provider, Riverpod, o cualquier otro
/// mecanismo de inyección de dependencias.
class SensorService {
  final SupabaseClient _client;

  /// Nombre de la tabla en Supabase.
  static const String _tableName = 'sensor_data';

  /// Crea el servicio con un [SupabaseClient].
  ///
  /// Esto permite inyectar un cliente mock para testing.
  SensorService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Obtiene la lectura más reciente del sensor.
  ///
  /// Retorna `null` si no hay datos disponibles.
  Future<SensorReading?> getLatestReading() async {
    final response = await _client
        .from(_tableName)
        .select()
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isEmpty) return null;

    return SensorReading.fromJson(response.first);
  }

  /// Obtiene las últimas [count] lecturas ordenadas de más reciente a
  /// más antigua.
  ///
  /// Por defecto retorna las últimas 20 lecturas.
  Future<List<SensorReading>> getRecentReadings({int count = 20}) async {
    final response = await _client
        .from(_tableName)
        .select()
        .order('created_at', ascending: false)
        .limit(count);

    return response
        .map<SensorReading>((json) => SensorReading.fromJson(json))
        .toList();
  }

  /// Obtiene lecturas en un rango de fechas específico.
  ///
  /// Útil para futuras funcionalidades de gráficos o reportes.
  Future<List<SensorReading>> getReadingsByDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _client
        .from(_tableName)
        .select()
        .gte('created_at', from.toIso8601String())
        .lte('created_at', to.toIso8601String())
        .order('created_at', ascending: false);

    return response
        .map<SensorReading>((json) => SensorReading.fromJson(json))
        .toList();
  }
}
