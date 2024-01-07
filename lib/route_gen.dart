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
      case "/importFromFlutterAction":
        return CupertinoPageRoute(
            builder: (_) => const ExtensionPage(Extensions.action, null));
      default:
        final passedExtensionWithData =
            settings.arguments as (Extensions, Object?);
        return CupertinoPageRoute(
          builder: (_) => ExtensionPage(
            passedExtensionWithData.$1,
            passedExtensionWithData.$2,
          ),
        );
    }
  }
}
