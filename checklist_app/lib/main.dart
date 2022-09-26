import 'package:checklist_app/core/routes/router.dart';
import 'package:checklist_app/core/util/app_aware.dart';
import 'package:checklist_app/core/util/themes.dart';
import 'package:checklist_app/env/env.dart';
import 'package:checklist_app/injection_container.dart';
import 'package:checklist_app/provider/auth_provider.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  Env().initConfig();
  await init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
      ChangeNotifierProvider(create: (_) => sl<ChecklistProvider>()),
    ],
    // Uncomment to run in preview mode
    // child: DevicePreview(
    //   enabled: true,
    //   builder: (context) => const MyApp(),
    // ),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = AppRoute.router;
    return AppAware(
      child: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return MaterialApp.router(
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            title: 'Checklist',
            theme: themeOptions[provider.currentTheme],
          );
        },
      ),
    );
  }
}
