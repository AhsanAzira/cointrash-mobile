import 'dart:math';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../store.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = true;
  Map<String, dynamic>? _result;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  void _simulateScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    final store = UserStore();

    if (store.wasteTypes.isEmpty) {
      // Provide a fallback if database is empty for testing
      setState(() {
        _isScanning = false;
        _result = {
          'id': 1,
          'name': 'Unknown Waste',
          'price_per_kg': 1000,
          'weight': 0.5,
          'quality': 'Standar',
          'icon': Icons.delete_outline,
        };
      });
      return;
    }

    final random = Random();
    final randomType =
        store.wasteTypes[random.nextInt(store.wasteTypes.length)];
    final weight = (random.nextInt(10) + 1) / 10.0; // 0.1 to 1.0 kg

    setState(() {
      _isScanning = false;
      _result = {
        'id': int.parse(randomType['id'].toString()),
        'name': randomType['name'],
        'price_per_kg': int.parse(randomType['price_per_kg'].toString()),
        'weight': weight,
        'quality': 'Standar',
        'icon': Icons.auto_awesome,
      };
    });
  }

  void _handleSubmit() async {
    if (_result == null) return;
    final store = UserStore();
    final coins =
        ((_result!['price_per_kg'] as int) * (_result!['weight'] as double))
            .toInt();

    final success = await store.addTransaction(
      _result!['id'] as int,
      _result!['weight'] as double,
      coins,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 +$coins koin dari ${_result!['name']}!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        setState(() {
          _isScanning = true;
          _result = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan transaksi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Scan Sampah'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primaryGreen],
            ),
          ),
        ),
      ),
      body: _isScanning ? _buildScanView() : _buildResultView(),
    );
  }

  Widget _buildScanView() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Camera placeholder
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Arahkan kamera ke sampah',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scan line animation
                AnimatedBuilder(
                  animation: _scanLineController,
                  builder: (context, child) {
                    return Positioned(
                      top:
                          _scanLineController.value *
                          (MediaQuery.of(context).size.height * 0.35),
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primaryGreen.withValues(alpha: 0.8),
                              AppColors.accentYellow,
                              AppColors.primaryGreen.withValues(alpha: 0.8),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Corner markers
                ..._buildCornerMarkers(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _simulateScan,
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 24),
              label: const Text(
                'Scan Sekarang',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  List<Widget> _buildCornerMarkers() {
    const size = 30.0;
    const thickness = 4.0;
    const color = AppColors.accentYellow;
    const offset = 16.0;

    return [
      // Top-left
      Positioned(
        top: offset,
        left: offset,
        child: _CornerMarker(size: size, thickness: thickness, color: color),
      ),
      // Top-right
      Positioned(
        top: offset,
        right: offset,
        child: Transform.flip(
          flipX: true,
          child: _CornerMarker(size: size, thickness: thickness, color: color),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: offset,
        left: offset,
        child: Transform.flip(
          flipY: true,
          child: _CornerMarker(size: size, thickness: thickness, color: color),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: offset,
        right: offset,
        child: Transform.flip(
          flipX: true,
          flipY: true,
          child: _CornerMarker(size: size, thickness: thickness, color: color),
        ),
      ),
    ];
  }

  Widget _buildResultView() {
    if (_result == null) return const SizedBox();
    final coins =
        ((_result!['price_per_kg'] as int) * (_result!['weight'] as double))
            .toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Result icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: Icon(
              _result!['icon'] as IconData,
              size: 56,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hasil Identifikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          // Info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _InfoRow(label: 'Nama', value: _result!['name'] as String),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Kualitas',
                  value: _result!['quality'] as String,
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Perkiraan Berat',
                  value:
                      '${(_result!['weight'] as double).toStringAsFixed(2)} kg',
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Harga/kg',
                  value: 'Rp ${_result!['price_per_kg']}',
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estimasi Koin',
                      style: TextStyle(fontSize: 14, color: AppColors.textGray),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/coin.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '+$coins',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isScanning = true;
                      _result = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: AppColors.primaryGreen),
                  ),
                  child: const Text(
                    'Scan Ulang',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Klaim Koin',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  final double size;
  final double thickness;
  final Color color;

  const _CornerMarker({
    required this.size,
    required this.thickness,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(thickness: thickness, color: color),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final double thickness;
  final Color color;

  _CornerPainter({required this.thickness, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textGray),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
