import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = UserStore();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 56,
                    left: 20,
                    right: 20,
                    bottom: 32,
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
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentYellow,
                            width: 3,
                          ),
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 48,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        store.userName.isNotEmpty ? store.userName : 'User',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.userEmail.isNotEmpty
                            ? store.userEmail
                            : 'user@email.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Menu items
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profil',
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.shield_outlined,
                        title: 'Keamanan',
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifikasi',
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Bantuan & FAQ',
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'CoinTrash',
                            applicationVersion: '1.0.0 MVP',
                            applicationLegalese:
                                '© 2026 Kelompok 3 - Software Startup Business',
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await store.logout();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/signin',
                                (_) => false,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.dangerRed,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.dangerRed,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: const BorderSide(color: AppColors.dangerRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textGray),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
