import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions/action_content.dart';

enum Extensions {
  action(
    "Action",
    content: ActionContent(),
    description:
        "Action Extensions are custom actions that are added to the share sheet to invoke your application from any other app.",
  ),
  autofill("Autofill", content: SizedBox.shrink(), description: ""),
  callkit("Callkit", content: SizedBox.shrink(), description: ""),
  widget("Widget", content: SizedBox.shrink(), description: ""),
  spotlight("Spotlight", content: SizedBox.shrink(), description: ""),
  appclip("Appclip", content: SizedBox.shrink(), description: "");

  const Extensions(
    this.name, {
    required this.content,
    required this.description,
  });

  final String name;
  final Widget content;
  final String description;
}
