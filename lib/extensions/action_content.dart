import 'package:flutter/cupertino.dart';

class ActionContent extends StatelessWidget {
  const ActionContent({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoButton.filled(
          child: const Text("Trigger action"),
          onPressed: () => {},
        ),
      );
}
