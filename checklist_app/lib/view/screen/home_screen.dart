import 'package:checklist_app/core/platform_specific/platform_icons.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/view/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: Config.contentPadding(context, h: 3),
            child: GestureDetector(
              onTap: () => context.push(ProfileScreen.route),
              child: Icon(
                AppIcons.profile,
                size: 40,
              ),
            ),
          )
        ],
      ),
      body: Column(),
      floatingActionButton: FloatingActionButton(
        child: Icon(AppIcons.add, size: 40),
        onPressed: () {},
      ),
    );
  }
}
