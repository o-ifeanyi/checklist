import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/injection_container.dart';
import 'package:checklist_app/view/screen/auth_screen.dart';
import 'package:checklist_app/view/screen/home_screen.dart';
import 'package:checklist_app/view/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final router = GoRouter(
    initialLocation: sl<HiveService>().getToken().isEmpty
        ? AuthScreen.route
        : HomeScreen.route,
    routes: <GoRoute>[
      GoRoute(
        name: 'auth_screen',
        path: AuthScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthScreen();
        },
      ),
      GoRoute(
        name: 'home_screen',
        path: HomeScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        name: 'profile_screen',
        path: ProfileScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
    ],
  );
}
