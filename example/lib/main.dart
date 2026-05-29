import 'package:flutter/material.dart';
import 'package:stacked_sheets/stacked_sheets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked Sheets Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StackedSheetController _controller = StackedSheetController();

  void _pushSheet() {
    final sheetIndex = _controller.sheets.length + 1;
    _controller.push(
      StackedSheet(
        initialExtent: 0.7 - (sheetIndex * 0.05).clamp(0, 0.2),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stacked Sheet #$sheetIndex',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _controller.pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                'This is sheet number $sheetIndex in the stack.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pushSheet,
                  child: const Text('Push Another Sheet'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _controller.pop(),
                  child: const Text('Pop This Sheet'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The StackedSheetCoordinator must wrap the widget tree where the overlay should appear.
    // Usually, wrapping the Scaffold or the home widget is appropriate.
    return StackedSheetCoordinator(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Stacked Sheets'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.layers, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                'Stacked Sheets Demonstration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'This example shows how to use the StackedSheetCoordinator and StackedSheetController to manage multiple stacked bottom sheets.',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _pushSheet,
                icon: const Icon(Icons.add),
                label: const Text('Open First Sheet'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
