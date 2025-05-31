import 'package:flutter/cupertino.dart';
import 'package:golden_ios_extensions/extension_list.dart';
import 'package:golden_ios_extensions/extensions.dart';
import 'package:golden_ios_extensions/route_gen.dart';
import 'package:quick_actions/quick_actions.dart';

final _navKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    const QuickActions quickActions = QuickActions();
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_main',
          localizedTitle: 'To Quick Action Page',
          icon: 'AppIcon'),
    ]);

    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_main') {
        _navKey.currentState?.pushNamed(
          GoldenExtensionRoutes.homeScreenQuickActions.path,
          arguments: (Extensions.homeScreenQuickActions, null),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CupertinoApp(
        navigatorKey: _navKey,
        debugShowCheckedModeBanner: false,
        home: const ExtensionList(),
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      );
}
