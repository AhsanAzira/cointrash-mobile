import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../store.dart';
import '../widgets/coin_popup.dart';

class PointScreen extends StatefulWidget {
  const PointScreen({super.key});

  @override
  State<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  final _store = UserStore();

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
              // Menarik data terbaru dari MySQL (api.php)
              await _store.fetchUserData();
            },
            child: CustomScrollView(
              // Wajib agar layar tetap bisa ditarik meski riwayatnya sedikit
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header with coin balance
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 56,
                      left: 20,
                      right: 20,
                      bottom: 28,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryDark, AppColors.primaryGreen],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Koin Kamu Sekarang',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/coin.png',
                              width: 36,
                              height: 36,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${_store.coinBalance}',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accentYellow,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 180,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur Cairkan (coming soon)'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentYellow,
                              foregroundColor: AppColors.textDark,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Cairkan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _QuickAction(
                          icon: Icons.location_on_outlined,
                          label: 'Lokasi',
                          onTap: () {},
                        ),
                        _QuickAction(
                          icon: Icons.local_shipping_outlined,
                          label: 'Kurir',
                          onTap: () {},
                        ),
                        _QuickAction(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Shop',
                          onTap: () {},
                        ),
                        _QuickAction(
                          icon: Icons.add_circle_outline,
                          label: 'Simulasi',
                          onTap: () =>
                              showCoinPopup(context, 500, 'TPS Intan Sari'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Transaction history title
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 12),
                    child: Text(
                      'Riwayat Koin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),

                // Transaction list
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final tx = _store.transactions[index];
                      final isCredit = tx['type'] == 'credit';
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
                                color: isCredit
                                    ? AppColors.successGreen.withValues(
                                        alpha: 0.12,
                                      )
                                    : AppColors.dangerRed.withValues(
                                        alpha: 0.12,
                                      ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isCredit
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: isCredit
                                    ? AppColors.successGreen
                                    : AppColors.dangerRed,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    tx['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isCredit ? '+' : ''}${tx['amount']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isCredit
                                        ? AppColors.successGreen
                                        : AppColors.dangerRed,
                                  ),
                                ),
                                Text(
                                  tx['date'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }, childCount: _store.transactions.length),
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
