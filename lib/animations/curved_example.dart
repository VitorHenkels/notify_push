import 'package:flutter/material.dart';

class CurvedExample extends StatefulWidget {
  const CurvedExample({super.key});

  @override
  State<CurvedExample> createState() => _CurvedExampleState();
}

class _CurvedExampleState extends State<CurvedExample>{
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller.forward();
    super.initState();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() => _controller.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ScaleTransition(
        scale: _animation,
        child: Container(width: 100, height: 20, color: Colors.blue),
      ),
    ),
  );
}
}