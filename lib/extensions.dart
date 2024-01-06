import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extensions/action_content.dart';

enum Extensions {
  action("Action", content: ActionContent()),
  autofill("Autofill"),
  callkit("Callkit"),
  widget("Widget"),
  spotlight("Spotlight"),
  appclip("Appclip");

  const Extensions(this.name, {this.content});
  final String name;
  final Widget? content;
}
