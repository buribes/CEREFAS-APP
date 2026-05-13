import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/sensor_reading.dart';

/// Tarjeta grande para mostrar una lectura de sensor (temperatura o humedad).
///
/// Cambia de color según el estado de alerta:
/// - Verde cuando el valor está en rango normal.
/// - Rojo cuando supera el umbral configurado.
class ReadingCard extends StatelessWidget {
  /// Etiqueta descriptiva (ej. "Temperatura", "Humedad").
  final String label;

  /// Valor formateado para mostrar (ej. "25.3°C").
  final String value;

  /// Unidad de medida (ej. "°C", "%").
  final String unit;

  /// Ícono a mostrar en la tarjeta.
  final IconData icon;

  /// Indica si el valor está en estado de alerta.
  final bool isAlert;

  /// Indica si los datos están cargando.
  final bool isLoading;

  const ReadingCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.isAlert = false,
    this.isLoading = false,
  });

  /// Constructor de conveniencia para temperatura.
  factory ReadingCard.temperature({
    Key? key,
    SensorReading? reading,
    bool isLoading = false,
  }) {
    return ReadingCard(
      key: key,
      label: 'Temperatura',
      value: reading != null ? reading.temperature.toStringAsFixed(1) : '--',
      unit: '°C',
      icon: Icons.thermostat_rounded,
      isAlert: reading?.isTemperatureAlert ?? false,
      isLoading: isLoading,
    );
  }

  /// Constructor de conveniencia para humedad.
  factory ReadingCard.humidity({
    Key? key,
    SensorReading? reading,
    bool isLoading = false,
  }) {
    return ReadingCard(
      key: key,
      label: 'Humedad',
      value: reading != null ? reading.humidity.toStringAsFixed(1) : '--',
      unit: '%',
      icon: Icons.water_drop_rounded,
      isAlert: reading?.isHumidityAlert ?? false,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Colores según estado de alerta con gradientes suaves.
    final Color primaryColor = isAlert
        ? const Color(0xFFE53935) // Rojo alerta
        : const Color(0xFF43A047); // Verde normal

    final Color lightColor = isAlert
        ? const Color(0xFFFF8A80)
        : const Color(0xFF81C784);

    final Color bgStart = isAlert
        ? const Color(0xFFFFF0F0)
        : const Color(0xFFF0FFF4);

    final Color bgEnd = isAlert
        ? const Color(0xFFFFE0E0)
        : const Color(0xFFE0F5E6);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgStart, bgEnd],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: ícono + label
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                // Indicador de estado
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isAlert ? 'Alerta' : 'Normal',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Valor principal
            if (isLoading)
              Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: primaryColor,
                  ),
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(
                      value,
                      key: ValueKey(value),
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      unit,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: lightColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
