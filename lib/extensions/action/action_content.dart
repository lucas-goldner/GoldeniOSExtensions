import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions/action/action_import_file_channel.dart';

class ActionContent extends StatelessWidget {
  const ActionContent(this.importedFiles, {super.key});
  final List<ImportedFile>? importedFiles;

  @override
  Widget build(BuildContext context) => switch (importedFiles) {
        null => const SizedBox.shrink(),
        List<ImportedFile> list when list.isEmpty => const SizedBox.shrink(),
        _ => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(importedFiles![importedFiles!.length - 1].path),
          ),
      };
}
