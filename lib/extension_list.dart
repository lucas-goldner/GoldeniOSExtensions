import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extension_item.dart';
import 'package:golden_ios_extensions/extensions.dart';
import 'package:golden_ios_extensions/extensions/action/action_import_file_channel.dart';

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
                StreamBuilder<List<ImportedFile>>(
                  stream: ImportFileChannel().getMediaStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ExtensionItem(
                        extension: Extensions.action,
                        data: snapshot.requireData,
                      );
                    }

                    return const ExtensionItem(
                      extension: Extensions.action,
                    );
                  },
                ),
                for (final extension in Extensions.values.skip(1))
                  ExtensionItem(
                    extension: extension,
                  ),
              ],
            ),
          ),
        ),
      );
}
