import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extension_item.dart';
import 'package:golden_ios_extensions/extensions.dart';

class ExtensionList extends StatefulWidget {
  const ExtensionList({super.key});

  @override
  State<ExtensionList> createState() => _ExtensionListState();
}

class _ExtensionListState extends State<ExtensionList> {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            'Welcome to Golden iOS Extensions!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
                for (final extension in Extensions.values)
                  ExtensionItem(
                    extension: extension,
                  ),
              ],
            ),
          ),
        ),
      );
}
