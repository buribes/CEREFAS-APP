import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/sensor_reading.dart';
import '../services/sensor_service.dart';
import '../widgets/history_list.dart';
import '../widgets/reading_card.dart';

/// Pantalla principal de la aplicación CEREFAS.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  SensorReading? _latestReading;
  List<SensorReading> _history = [];
  bool _isFirstLoad = true;
  String? _errorMessage;
  Timer? _pollTimer;
  DateTime? _lastUpdated;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _fetchData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      final service = context.read<SensorService>();
      final results = await Future.wait([
        service.getLatestReading(),
        service.getRecentReadings(count: 20),
      ]);
      if (!mounted) return;
      setState(() {
        _latestReading = results[0] as SensorReading?;
        _history = results[1] as List<SensorReading>;
        _isFirstLoad = false;
        _errorMessage = null;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFirstLoad = false;
        _errorMessage = 'Error al cargar datos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchData,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(theme)),
              if (_errorMessage != null)
                SliverToBoxAdapter(child: _buildErrorBanner()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ReadingCard.temperature(
                        reading: _latestReading,
                        isLoading: _isFirstLoad,
                      ),
                      const SizedBox(height: 16),
                      ReadingCard.humidity(
                        reading: _latestReading,
                        isLoading: _isFirstLoad,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: _buildHistoryHeader(theme),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: HistoryList(
                    readings: _history,
                    isLoading: _isFirstLoad,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.history_rounded, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Text(
          'Historial reciente',
          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface),
        ),
        const Spacer(),
        Text(
          '${_history.length} lecturas',
          style: GoogleFonts.inter(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final timeFormat = DateFormat('HH:mm:ss');
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF43A047).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.pets_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CEREFAS', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                    const SizedBox(height: 2),
                    Text('Monitor Ambiental', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface.withValues(alpha: 0.55))),
                  ],
                ),
              ),
              _buildLiveIndicator(),
            ],
          ),
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Icon(Icons.update_rounded, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                  const SizedBox(width: 6),
                  Text('Última actualización: ${timeFormat.format(_lastUpdated!)}', style: GoogleFonts.inter(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLiveIndicator() {
    final bool hasError = _errorMessage != null;
    final Color color = hasError ? const Color(0xFFE53935) : const Color(0xFF43A047);
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06 + _pulseController.value * 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: color.withValues(alpha: _pulseController.value * 0.6), blurRadius: 6)],
                ),
              ),
              const SizedBox(width: 6),
              Text(hasError ? 'Error' : 'En vivo', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3F0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFE53935), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_errorMessage!, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFE53935)), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh_rounded, color: Color(0xFFE53935), size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          ],
        ),
      ),
    );
  }
}
