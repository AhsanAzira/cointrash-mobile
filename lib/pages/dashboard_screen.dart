import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../app_theme.dart';
import '../store.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _store = UserStore();

  // Dynamic prices from API loaded in store.wasteTypes
  // Fallback icons for display
  final Map<String, IconData> _wasteIcons = {
    'Plastik PET': Icons.local_drink,
    'Kardus': Icons.inventory_2,
    'Kertas HVS': Icons.description,
    'Besi / Logam': Icons.hardware,
    'Kaca / Botol': Icons.wine_bar,
    'Aluminium': Icons.auto_awesome,
    'default': Icons.delete_outline,
  };

  List<Map<String, dynamic>> get _trashPrices {
    return _store.wasteTypes.take(6).map((waste) {
      final icon = _wasteIcons[waste['name'] ?? ''] ?? _wasteIcons['default']!;
      return {
        'name': waste['name'] ?? 'Unknown',
        'price': waste['price_per_kg'] ?? 0,
        'icon': icon,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: ListenableBuilder(
        listenable: _store,
        builder: (context, _) {
          // Menambahkan RefreshIndicator di sini
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            backgroundColor: AppColors.white,
            onRefresh: () async {
              // Menarik data terbaru dari MySQL (api.php) saat layar ditarik
              await _store.fetchUserData();
            },
            child: CustomScrollView(
              // Wajib agar layar tetap bisa ditarik meski kontennya sedikit
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 64,
                      left: 20,
                      right: 20,
                      bottom: 16,
                    ),
                    color: AppColors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 32,
                                    color: AppColors.textDark,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dari masa depan',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Tetap jaga kebersihan, ${_store.userName.isNotEmpty ? _store.userName : "April"}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textDark,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // Coin badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/coin.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${_store.coinBalance}',
                                    style: const TextStyle(
                                      color: AppColors.accentYellow,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Notification bell
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: AppColors.textDark,
                                size: 24,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Belum ada notifikasi baru',
                                    ),
                                    backgroundColor: AppColors.primaryGreen,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Level Progress
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                      child: Row(
                        children: [
                          CircularPercentIndicator(
                            radius: 48,
                            lineWidth: 8,
                            percent: _store.trashCount / 100,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.park_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 28,
                                ),
                                Text(
                                  'Lv ${_store.level}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                            progressColor: AppColors.primaryGreen,
                            backgroundColor: AppColors.primaryGreen.withValues(
                              alpha: 0.15,
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Level Progress',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_store.trashCount}/100 Trash Needed',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: _store.trashCount / 100,
                                    minHeight: 8,
                                    backgroundColor: AppColors.primaryGreen
                                        .withValues(alpha: 0.15),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryGreen,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Kontribusi
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.delete_outline_rounded,
                            label: 'Total Sampah',
                            value: '${_store.totalTrashKg} kg',
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.receipt_long_outlined,
                            label: 'Total Transaksi',
                            value: '${_store.totalTransactions}',
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Section Title
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 24,
                      bottom: 12,
                    ),
                    child: Text(
                      'Harga Sampah Terkini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),

                // Trash Price List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = _trashPrices[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: AppColors.primaryGreen,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            Text(
                              'Rp ${item['price']}/kg',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: _trashPrices.length),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textGray),
          ),
        ],
      ),
    );
  }
}
