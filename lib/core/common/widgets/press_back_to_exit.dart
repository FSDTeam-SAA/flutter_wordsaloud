import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressBackToExit extends StatefulWidget {
  final Widget child;

  const PressBackToExit({super.key, required this.child});

  @override
  State<PressBackToExit> createState() => _PressBackToExitState();
}

class _PressBackToExitState extends State<PressBackToExit> {
  DateTime? _lastBackPressedAt;

  Future<void> _handleBackPressed() async {
    final now = DateTime.now();
    final shouldExit =
        _lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) <= const Duration(seconds: 2);

    if (shouldExit) {
      await SystemNavigator.pop();
      return;
    }

    _lastBackPressedAt = now;

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: widget.child,
    );
  }
}
