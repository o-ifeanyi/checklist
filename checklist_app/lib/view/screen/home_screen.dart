import 'package:checklist_app/core/constants/constants.dart';
import 'package:checklist_app/core/platform_specific/platform_icons.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:checklist_app/view/screen/checklist_screen.dart';
import 'package:checklist_app/view/screen/profile_screen.dart';
import 'package:checklist_app/view/widget/checklist_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late ChecklistProvider _provider;
  late ValueListenable<Box<dynamic>> _checklistBox;
  bool _markAll = false;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ChecklistProvider>();
    WidgetsBinding.instance.addObserver(this);
    _checklistBox = Hive.box(kHiveBoxes.checklist.name).listenable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getAll();
      _checklistBox.addListener(() {
        _provider.getAll();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _checklistBox.removeListener(() {});
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _provider.sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<ChecklistProvider>();
    final checklists = _provider.allChecklist;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: Config.yMargin(context, 11),
              padding: Config.contentPadding(context),
              child: _provider.marked.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              'Select all  (${_provider.marked.length})',
                              style: Config.b1b(context),
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: _markAll,
                            onChanged: (val) {
                              if (val == null) return;
                              _markAll = val;
                              _provider.markAll(val);
                            },
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            _provider.delete(_provider.marked).then((sucess) {
                              _provider.markAll(false);
                            });
                          },
                          child: Icon(
                            AppIcons.delete,
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: Config.b1(context),
                            decoration: InputDecoration(
                              labelText: 'Search',
                              prefixIcon: Icon(AppIcons.search),
                              errorStyle: Config.b2(context),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => context.push(ProfileScreen.route),
                          child: Icon(
                            AppIcons.setting,
                            size: 30,
                          ),
                        )
                      ],
                    ),
            ),
            Expanded(
              child: MasonryGridView.builder(
                padding: Config.contentPadding(context),
                itemCount: checklists.length,
                gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: Config.xMargin(context, 50),
                ),
                crossAxisSpacing: Config.xMargin(context, 3),
                mainAxisSpacing: Config.yMargin(context, 2),
                itemBuilder: (context, index) {
                  final checklist = checklists[index];
                  return ChecklistItem(checklist: checklist);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(AppIcons.add, size: 40),
        onPressed: () => context.push(ChecklistScreen.route),
      ),
    );
  }
}
