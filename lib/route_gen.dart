import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extension_list.dart';
import 'package:golden_ios_extensions/extension_page.dart';
import 'package:golden_ios_extensions/extensions.dart';
import 'package:golden_ios_extensions/extensions/action/action_page_from_extension.dart';

enum GoldenExtensionRoutes {
  initRoute("/"),
  importFromFlutterAction("/importFromFlutterAction");

  const GoldenExtensionRoutes(this.path);
  final String path;
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String removePrefix(String input) {
      String prefix = GoldenExtensionRoutes.importFromFlutterAction.path;
      if (input.startsWith(prefix)) {
        return input.substring(prefix.length);
      }
      return input;
    }

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const ExtensionList());
      case String s
          when s.contains(GoldenExtensionRoutes.importFromFlutterAction.path):
        return CupertinoPageRoute(
            builder: (_) =>
                ActionPageFromExtension(removePrefix(settings.name ?? "")));
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
