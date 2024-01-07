import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extension_page.dart';
import 'package:golden_ios_extensions/extensions.dart';
import 'package:golden_ios_extensions/route_gen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: const ExtensionPage(Extensions.action),
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      );
}
