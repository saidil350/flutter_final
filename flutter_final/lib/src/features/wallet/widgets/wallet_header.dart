import 'package:flutter/material.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(
            'assets/images/avatar.png',
          ), // Placeholder
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Color(0xFF1F2937)),
        ),
      ],
    );
  }
}
