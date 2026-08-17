import 'package:flutter/material.dart';

class AppBackgroudDesignWidget extends StatelessWidget {
  final Widget? child;

  const AppBackgroudDesignWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5EDE8), Color(0xFFE7D7C9)],
        ),
      ),
      child: Container(color: Colors.white.withAlpha(150), child: child),
    );
  }
}
