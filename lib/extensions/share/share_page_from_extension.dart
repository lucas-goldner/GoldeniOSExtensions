import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SharePageFromExtension extends StatefulWidget {
  const SharePageFromExtension({super.key});
  static const platform =
      MethodChannel('com.lucas-goldner.golden-ios-extensions/shareLink');

  @override
  State<SharePageFromExtension> createState() => _SharePageFromExtensionState();
}

class _SharePageFromExtensionState extends State<SharePageFromExtension> {
  TextEditingController controller = TextEditingController();

  Future<void> importIntoApp() async {
    try {
      await SharePageFromExtension.platform
          .invokeMethod('shareLinkWithDescription', controller.text);
    } on PlatformException catch (e) {
      log("Failed to print message: '${e.message}'.", level: 3);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                CupertinoTextField(
                  controller: controller,
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoButton.filled(
                  onPressed: importIntoApp,
                  child: const Text("Share with app"),
                ),
              ],
            ),
          ),
        ),
      );
}
