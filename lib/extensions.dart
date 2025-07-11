import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions/action/action_content.dart';
import 'package:golden_ios_extensions/extensions/action/action_import_file_channel.dart';
import 'package:golden_ios_extensions/extensions/share/share_content.dart';

enum Extensions {
  action(
    "Action",
    description:
        "Action Extensions are custom actions that are added to the share sheet to invoke your application from any other app.",
  ),
  homeScreenQuickActions('Home Screen Quick Actions',
      description:
          "Quick Actions are shortcuts that appear when the user long-presses your app icon on the home screen."),
  autofill("Autofill", description: ""),
  callkit("Callkit", description: ""),
  widget("Widget", description: ""),
  spotlight("Spotlight", description: ""),
  appclip("Appclip", description: ""),
  share(
    "Share",
    description: "Lets users share certain content into your app.",
  );

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
        Extensions.share =>
          ShareContent(data == null ? null : data as (String, String)),
        Extensions.homeScreenQuickActions => const SizedBox.shrink(),
        Extensions.autofill => const SizedBox.shrink(),
        Extensions.callkit => const SizedBox.shrink(),
        Extensions.widget => const SizedBox.shrink(),
        Extensions.spotlight => const SizedBox.shrink(),
        Extensions.appclip => const SizedBox.shrink()
      };
}
