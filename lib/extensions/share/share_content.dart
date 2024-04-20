import 'package:flutter/cupertino.dart';

class ShareContent extends StatelessWidget {
  const ShareContent(this.receivedData, {super.key});
  final (String, String)? receivedData;

  @override
  Widget build(BuildContext context) => switch (receivedData) {
        null => const SizedBox.shrink(),
        _ => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Title: ${receivedData!.$1}"),
                Text("Content: ${receivedData!.$2}"),
              ],
            ),
          ),
      };
}
