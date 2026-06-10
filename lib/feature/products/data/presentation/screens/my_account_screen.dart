import 'package:flutter/material.dart';
import 'package:with_api/feature/products/data/auth/services/shared_pref/auth_shared.dart';
import 'package:with_api/feature/products/data/cart/hive/cart_service.dart';
import 'package:with_api/feature/products/data/wishlist/hive/wishlist_hive.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<void> handleUserLogout(BuildContext context) async {
    try {
      if (context.mounted) {
        // context.read<WishlistCubit>().clearWishlistState();
        // context.read<CartCubit>().onCartClear();
      }

      await PreferenceService.clearAuthData();

      await HiveWishlistService.closeUserBox();
      await HiveCartService.closeUserBox();
      // await HiveAddressService.closeUserBox();
      // await HiveOrderService.closeUserBox();

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      debugPrint("Error during logout sequence: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildProfileHeader(),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      onTap: () {
                        Navigator.pushNamed(context, '/wishlist');
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on,
                      title: 'Saved addresses',
                      onTap: () {
                        Navigator.pushNamed(context, '/address');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  textColor: Colors.red.shade700,
                  iconColor: Colors.red.shade700,
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    handleUserLogout(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
          child: const Icon(Icons.person, size: 55, color: Colors.black),
        ),
        const SizedBox(height: 12),

        const SizedBox(height: 4),

        FutureBuilder<String>(
          future:
              PreferenceService.getUserEmail(),
          builder: (context, snapshot) {
            String email = 'Loading...';

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              email = snapshot.data!;
            }
            return Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: textColor,
        ),
      ),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, right: 16.0),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}
