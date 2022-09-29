import 'package:checklist_app/core/platform_specific/dialog_loader.dart';
import 'package:checklist_app/core/platform_specific/platform_alert_dialog.dart';
import 'package:checklist_app/core/platform_specific/platform_icons.dart';
import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/core/util/themes.dart';
import 'package:checklist_app/injection_container.dart';
import 'package:checklist_app/provider/auth_provider.dart';
import 'package:checklist_app/view/screen/auth_screen.dart';
import 'package:checklist_app/view/screen/privacy_policy.dart';
import 'package:checklist_app/view/screen/terms_condition.dart';
import 'package:checklist_app/view/widget/constrained_box.dart';
import 'package:checklist_app/view/widget/custom_list_tile.dart';
import 'package:checklist_app/view/widget/delete_guidelines.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthProvider _authProvider;
  late ThemeOptions _selectedTheme;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _selectedTheme = _authProvider.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBoxWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My account', style: Config.h2(context)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Config.yMargin(context, 2)),
            Expanded(
              child: ListView(
                padding: Config.contentPadding(context),
                children: [
                  CustomListTile(
                    iconData: AppIcons.terms,
                    title: 'Terms of service',
                    onPressed: () => context.push(TermsAndConditions.route),
                  ),
                  CustomListTile(
                    iconData: AppIcons.privacy,
                    title: 'Privacy policy',
                    onPressed: () => context.push(PrivacyPolicy.route),
                  ),
                  SizedBox(height: Config.yMargin(context, 1)),
                  CupertinoSlidingSegmentedControl<ThemeOptions>(
                    groupValue: _selectedTheme,
                    thumbColor: theme.backgroundColor,
                    backgroundColor: theme.colorScheme.secondary,
                    padding: Config.contentPadding(context, h: 3, v: 1),
                    children: {
                      ThemeOptions.light: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Light', style: Config.b1(context)),
                      ),
                      ThemeOptions.dark:
                          Text('Dark', style: Config.b1(context)),
                      ThemeOptions.system:
                          Text('System', style: Config.b1(context)),
                    },
                    onValueChanged: (option) {
                      if (option != null)
                        setState(() {
                          _selectedTheme = option;
                        });
                      _authProvider.currentTheme = _selectedTheme;
                      sl<HiveService>().setTheme(_selectedTheme);
                    },
                  ),
                  SizedBox(height: Config.yMargin(context, 1)),
                  CustomListTile(
                    key: const ValueKey('logout_button'),
                    iconData: AppIcons.logout,
                    title: 'Logout',
                    onPressed: () async {
                      await _authProvider.logout().then((success) {
                        if (success) context.go(AuthScreen.route);
                      });
                    },
                  ),
                  CustomListTile(
                    key: const ValueKey('delete_acc_button'),
                    iconData: AppIcons.delete,
                    highlightColor: theme.errorColor,
                    title: 'Delete account',
                    onPressed: () async {
                      final shouldDelete = await showModalBottomSheet<bool?>(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => SizedBox(
                          height: Config.yMargin(context, 70),
                          child: const DeleteGuidelines(),
                        ),
                      );
                      if (shouldDelete == null) return;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return PlatformAlertDialog(
                            title: 'Are you sure?',
                            content: Text(
                              'This action cannot be reversed or canceled once initiated.',
                              style: Config.b1(context),
                            ),
                            actions: [
                              DialogAction(
                                text: 'Cancel',
                                onPressed: () => Navigator.pop(context),
                              ),
                              DialogAction(
                                isDefaultAction: true,
                                text: 'Continue',
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return DialogLoader(
                                          function: _authProvider.delete,
                                        );
                                      }).then((success) {
                                    if (success == true)
                                      context.go(AuthScreen.route);
                                  });
                                  ;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
