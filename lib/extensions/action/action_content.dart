import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions/action/action_import_file_channel.dart';

class ActionContent extends StatelessWidget {
  const ActionContent({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<ImportedFile>>(
            stream: ImportFileChannel().getMediaStream(),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return Image.asset(snapshot.data!.first.path);
              }

              return const Text("Waiting for file import...");
            }),
      );
}
