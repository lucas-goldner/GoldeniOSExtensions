import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extension_list.dart';
import 'package:golden_ios_extensions/extension_page.dart';
import 'package:golden_ios_extensions/extensions.dart';

// Link for opening the app from the action extension
// ImportMedia-com.lucas-goldner.goldenIosExtensions://

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const ExtensionList());
      default:
        final extension = settings.arguments as Extensions;
        return CupertinoPageRoute(builder: (_) => ExtensionPage(extension));
    }
  }
}
