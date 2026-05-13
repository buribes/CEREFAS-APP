import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/sensor_reading.dart';

/// Widget que muestra el historial de las últimas mediciones de sensor
/// en una lista ordenada de más reciente a más antigua.
class HistoryList extends StatelessWidget {
  /// Lista de lecturas a mostrar.
  final List<SensorReading> readings;

  /// Indica si los datos están cargando.
  final bool isLoading;

  const HistoryList({
    super.key,
    required this.readings,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading && readings.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (readings.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sensors_off_rounded,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'Sin datos disponibles',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: readings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final reading = readings[index];
        return _HistoryItem(reading: reading, index: index);
      },
    );
  }
}

/// Elemento individual del historial de lecturas.
class _HistoryItem extends StatelessWidget {
  final SensorReading reading;
  final int index;

  const _HistoryItem({
    required this.reading,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd/MM/yyyy', 'es');
    final timeFormatter = DateFormat('HH:mm:ss', 'es');
    final localDate = reading.createdAt.toLocal();

    final bool hasAlert = reading.isTemperatureAlert || reading.isHumidityAlert;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasAlert
              ? const Color(0xFFE53935).withValues(alpha: 0.2)
              : theme.colorScheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Ícono de fecha
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.schedule_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            // Fecha y hora
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormatter.format(localDate),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeFormatter.format(localDate),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),

            // Temperatura
            _ValueChip(
              icon: Icons.thermostat_rounded,
              value: '${reading.temperature.toStringAsFixed(1)}°C',
              isAlert: reading.isTemperatureAlert,
            ),

            const SizedBox(width: 8),

            // Humedad
            _ValueChip(
              icon: Icons.water_drop_rounded,
              value: '${reading.humidity.toStringAsFixed(1)}%',
              isAlert: reading.isHumidityAlert,
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip pequeño que muestra un valor con ícono y color de alerta.
class _ValueChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool isAlert;

  const _ValueChip({
    required this.icon,
    required this.value,
    required this.isAlert,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isAlert
        ? const Color(0xFFE53935) // Rojo alerta
        : const Color(0xFF43A047); // Verde normal

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
