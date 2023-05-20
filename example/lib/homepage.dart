import 'package:flutter/material.dart';

import 'signal_group_screen.dart';
import 'signalscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(fontSize: 15),
        ),
        toolbarHeight: 45,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("Signal 1-1 message"),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignalTestScreen(),
                  ),
                );
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.group),
              label: const Text("Signal Group message"),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignalTestGroupScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
