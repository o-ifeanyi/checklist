import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/injection_container.dart';
import 'package:checklist_app/model/checklist.dart';
import 'package:checklist_app/view/screen/auth_screen.dart';
import 'package:checklist_app/view/screen/checklist_screen.dart';
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
        name: 'auth',
        path: AuthScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthScreen();
        },
      ),
      GoRoute(
        name: 'home',
        path: HomeScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        name: 'profile',
        path: ProfileScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        name: 'checklist',
        path: ChecklistScreen.route,
        builder: (BuildContext context, GoRouterState state) {
          final checklist =
              state.extra == null ? null : state.extra as ChecklistModel;
          return ChecklistScreen(checklist: checklist);
        },
      ),
    ],
  );
}
