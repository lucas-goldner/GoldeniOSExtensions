import 'package:flutter/cupertino.dart';

class ActionPageFromExtension extends StatelessWidget {
  const ActionPageFromExtension(this.imagePath, {super.key});
  final String imagePath;

  void _importIntoApp() {
    print("Importing into app...");
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Hello from Flutter!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  imagePath,
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoButton.filled(
                  onPressed: _importIntoApp,
                  child: const Text("Import into app"),
                ),
              ],
            ),
          ),
        ),
      );
}
