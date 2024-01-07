import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions/action/action_content.dart';
import 'package:golden_ios_extensions/extensions/action/action_import_file_channel.dart';

enum Extensions {
  action(
    "Action",
    description:
        "Action Extensions are custom actions that are added to the share sheet to invoke your application from any other app.",
  ),
  autofill("Autofill", description: ""),
  callkit("Callkit", description: ""),
  widget("Widget", description: ""),
  spotlight("Spotlight", description: ""),
  appclip("Appclip", description: "");

  const Extensions(
    this.name, {
    required this.description,
  });

  final String name;
  final String description;
}

extension ExtensionsExtension on Extensions {
  Widget buildWidgetWithData(Object? data) => switch (this) {
        Extensions.action =>
          ActionContent(data == null ? [] : data as List<ImportedFile>),
        Extensions.autofill => const SizedBox.shrink(),
        Extensions.callkit => const SizedBox.shrink(),
        Extensions.widget => const SizedBox.shrink(),
        Extensions.spotlight => const SizedBox.shrink(),
        Extensions.appclip => const SizedBox.shrink()
      };
}
