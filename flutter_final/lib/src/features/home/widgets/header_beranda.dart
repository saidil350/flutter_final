import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class HeaderBeranda extends StatelessWidget {
  const HeaderBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    // Fallback name or extract from email if metadata is empty
    final String displayName =
        user?.userMetadata?['full_name'] ??
        user?.email?.split('@')[0] ??
        'User';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=12',
              ), // Placeholder
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Pagi,',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Color(0xFF8B8B8B),
                  ),
                ),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF242424),
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF242424),
            size: 28,
          ),
        ),
      ],
    );
  }
}
