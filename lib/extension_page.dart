import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions.dart';

class ExtensionPage extends StatelessWidget {
  const ExtensionPage(this.extension, {super.key});
  final Extensions extension;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(extension.name),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                extension.content ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
}
