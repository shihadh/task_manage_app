import 'package:flutter/material.dart';
import '../../../core/constants/text_const.dart';

class PremiumFab extends StatelessWidget {
  const PremiumFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                TextConst.home['addTaskPending']!,
                style: const TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF302B63),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: Text(
          TextConst.home['newTask']!.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}
