import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ActionPageFromExtension extends StatelessWidget {
  const ActionPageFromExtension(this.imagePath, {super.key});
  final String imagePath;
  static const platform =
      MethodChannel('com.lucas-goldner.goldenIosExtensions/flutterImport');

  Future<void> importIntoApp() async {
    try {
      await platform.invokeMethod('openAppWithImagePath', imagePath);
    } on PlatformException catch (e) {
      log("Failed to print message: '${e.message}'.", level: 3);
    }
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
                  onPressed: importIntoApp,
                  child: const Text("Import into app"),
                ),
              ],
            ),
          ),
        ),
      );
}
