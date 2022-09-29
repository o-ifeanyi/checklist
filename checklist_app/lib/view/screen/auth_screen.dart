import 'package:checklist_app/core/platform_specific/platform_icons.dart';
import 'package:checklist_app/core/platform_specific/platform_progress_indicator.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/model/user.dart';
import 'package:checklist_app/provider/auth_provider.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:checklist_app/view/screen/home_screen.dart';
import 'package:checklist_app/view/widget/auth_button.dart';
import 'package:checklist_app/view/widget/constrained_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const String route = '/';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isRegister = false;
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBoxWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: Config.contentPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Config.yMargin(context, 4)),
                Icon(
                  AppIcons.check,
                  size: Config.textSize(context, 10),
                ),
                Text('Checklist', style: Config.h1(context)),
                SizedBox(height: Config.yMargin(context, 4)),
                TextFormField(
                  key: const ValueKey('email_field'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: Config.b1(context),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorStyle: Config.b2(context),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'email is required';
                    const emailRegex =
                        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
                    if (RegExp(emailRegex).hasMatch(val)) {
                      return null;
                    }
                    return 'invalid email';
                  },
                  onChanged: (val) async {
                    setState(() {});
                  },
                ),
                SizedBox(height: Config.yMargin(context, 3)),
                TextFormField(
                  key: const ValueKey('password_field'),
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  style: Config.b1(context),
                  obscureText: obscurePassword,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorStyle: Config.b2(context),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty)
                      return 'password is required';
                    return null;
                  },
                  onChanged: (val) async {
                    setState(() {});
                  },
                ),
                if (isRegister) ...[
                  SizedBox(height: Config.yMargin(context, 3)),
                  TextFormField(
                    key: const ValueKey('confirm_password_field'),
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    style: Config.b1(context),
                    obscureText: obscurePassword,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      errorStyle: Config.b2(context),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'password is required';
                      } else if (val.trim() !=
                          _passwordController.text.trim()) {
                        return 'password does not match';
                      }
                      return null;
                    },
                    onChanged: (val) async {
                      setState(() {});
                    },
                  ),
                ],
                SizedBox(height: Config.yMargin(context, 1)),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Show password', style: Config.b2(context)),
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  value: !obscurePassword,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      obscurePassword = !val;
                    });
                  },
                ),
                SizedBox(height: Config.yMargin(context, 1)),
                Consumer2<AuthProvider, ChecklistProvider>(
                  builder: (context, auth, check, child) {
                    return AnimatedSwitcher(
                      key: const ValueKey('auth_button'),
                      duration: const Duration(milliseconds: 300),
                      child: auth.authState == AuthState.register ||
                              auth.authState == AuthState.login ||
                              check.checkState == CheckState.sync
                          ? const PlatformProgressIndicator()
                          : AuthButton(
                              hPadding: 0,
                              text: isRegister ? 'Register' : 'Login',
                              onpressed: () async {
                                final isValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (!isValid) return;
                                final user = UserModel(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                bool success;
                                if (isRegister)
                                  success = await auth.register(user);
                                else
                                  success = await auth.login(user);
                                if (success) {
                                  await check.sync();
                                  context.go(HomeScreen.route);
                                }
                              },
                            ),
                    );
                  },
                ),
                SizedBox(height: Config.yMargin(context, 4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRegister
                          ? 'Already have an account?'
                          : 'Don\'t have an account?',
                      style: Config.b2(context),
                    ),
                    GestureDetector(
                      key: const ValueKey('auth_switch_button'),
                      onTap: () {
                        setState(() {
                          isRegister = !isRegister;
                        });
                      },
                      child: Text(
                        isRegister ? '  Log in  ' : '  Register  ',
                        style: Config.b2b(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Config.yMargin(context, 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
