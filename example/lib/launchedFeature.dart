import 'package:flutter/material.dart';

class LaunchedFeature extends StatelessWidget {
  const LaunchedFeature({super.key});

  // This widget is equivalent to the LaunchedFeature component in React.
  // It displays a non-editable TextField with the value passed via navigation.
  @override
  Widget build(BuildContext context) {
    // Retrieve the navigation arguments (expected to be a String)
    final value = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Launched Feature'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            // The TextField shows the value passed from the Home screen.
            controller: TextEditingController(text: value),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
