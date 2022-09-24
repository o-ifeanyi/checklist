import 'package:checklist_app/view/widget/checklist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'keys.dart';
import 'robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App test', () {
    testWidgets('User flow', (WidgetTester tester) async {
      final robot = Robot(tester);

      await robot.startApp();

      // Sign up
      expect(find.text('Checklist'), findsOneWidget);
      await robot.enterText(
          find.byKey(Keys.emailField), 'integrationtest@gmail.com');
      await robot.enterText(find.byKey(Keys.passwordField), '123456');
      await robot.enterText(find.byKey(Keys.confirmPassField), '12345');

      await robot.tap(find.byKey(Keys.authBtn));
      expect(find.text('password does not match'), findsOneWidget);
      await robot.enterText(find.byKey(Keys.confirmPassField), '123456');
      await robot.tap(find.byKey(Keys.authBtn));

      // Create checklist
      await robot.waitFor(find.byKey(Keys.addBtn), matcher: findsOneWidget);
      await robot.tap(find.byKey(Keys.addBtn));
      expect(find.text('title'), findsOneWidget);
      await robot.enterText(find.byKey(Keys.titleField), 'Test');
      await robot.enterText(find.byType(TextFormField).last, 'First task');
      await robot.tap(find.byKey(Keys.addNewItemBtn));
      await robot.enterText(find.byType(TextFormField).last, 'Second task');
      await robot.tap(find.byKey(Keys.addNewItemBtn));
      await robot.enterText(find.byType(TextFormField).last, 'Third task');
      await robot.tap(find.byType(BackButton));
      expect(find.byType(ChecklistItem), findsNWidgets(1));

      // Update checklist
      await robot.tap(find.byType(ChecklistItem).first);
      expect(find.text('First task'), findsOneWidget);
      expect(find.text('Second task'), findsOneWidget);
      expect(find.text('Third task'), findsOneWidget);

      expect(find.byType(Divider), findsNothing);
      await robot.tapAt(find.byType(CheckboxListTile).last, x: 35);
      await robot.waitFor(find.byKey(Keys.divider), matcher: findsOneWidget);
      await robot.tap(find.byType(BackButton));

      // Create checklist
      await robot.waitFor(find.byKey(Keys.addBtn), matcher: findsOneWidget);
      await robot.tap(find.byKey(Keys.addBtn));
      expect(find.text('title'), findsOneWidget);
      await robot.enterText(find.byKey(Keys.titleField), 'Search');
      await robot.tap(find.byType(BackButton));
      expect(find.byType(ChecklistItem), findsNWidgets(2));

      // Logout
      await robot.tap(find.byKey(Keys.profileBtn));
      expect(find.text('My account'), findsOneWidget);
      await robot.tap(find.byKey(Keys.logoutBtn));

      // Login
      expect(find.text('Checklist'), findsOneWidget);
      await robot.tap(find.byKey(Keys.authSwitchBtn));
      await robot.enterText(
          find.byKey(Keys.emailField), 'integrationtest@gmail.com');
      await robot.enterText(find.byKey(Keys.passwordField), '123456');
      await robot.tap(find.byKey(Keys.authBtn));

      await robot.enterText(find.byKey(Keys.searchField), 'Search');
      expect(find.byType(ChecklistItem), findsNWidgets(1));
      await robot.enterText(find.byKey(Keys.searchField), '');
      expect(find.byType(ChecklistItem), findsNWidgets(2));

      // Delete checklist
      expect(find.text('Select all  (1)'), findsNothing);
      await robot.longPress(find.byType(ChecklistItem).at(0));
      expect(find.text('Select all  (1)'), findsOneWidget);
      await robot.longPress(find.byType(ChecklistItem).at(1));
      expect(find.text('Select all  (2)'), findsOneWidget);
      await robot.tap(find.byKey(Keys.deleteBtn));
      expect(find.byType(ChecklistItem), findsNothing);

      // Delete account
      await robot.tap(find.byKey(Keys.profileBtn));
      expect(find.text('My account'), findsOneWidget);
      await robot.tap(find.byKey(Keys.deleteAccBtn));
      expect(find.text('Deleting your account would lead to the loss of:'),
          findsOneWidget);
      await robot.tap(find.byKey(Keys.contDeleteAccBtn));
      expect(find.text('Are you sure?'), findsOneWidget);
      await robot.tap(find.text('Continue'));

      expect(find.text('My account'), findsNothing);
      expect(find.text('Checklist'), findsOneWidget);

      // Login
      await robot.tap(find.byKey(Keys.authSwitchBtn));
      await robot.enterText(
          find.byKey(Keys.emailField), 'integrationtest@gmail.com');
      await robot.enterText(find.byKey(Keys.passwordField), '123456');
      await robot.tap(find.byKey(Keys.authBtn));
      await robot.waitFor(find.text('wrong email or password'),
          matcher: findsOneWidget);

      await robot.destroy();
    });
  });
}
