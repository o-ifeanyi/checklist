import 'package:checklist_app/core/constants/constants.dart';
import 'package:checklist_app/core/platform_specific/platform_icons.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:checklist_app/view/screen/checklist_screen.dart';
import 'package:checklist_app/view/screen/profile_screen.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  late ChecklistProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<ChecklistProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChecklistProvider>();
    final checklists = provider.allChecklist;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: Config.contentPadding(context),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: Config.b1(context),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorStyle: Config.b2(context),
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
            SizedBox(height: Config.yMargin(context, 2)),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box(kHiveBoxes.checklist.name).listenable(),
                builder: (context, _, child) {
                  return MasonryGridView.builder(
                    padding: Config.contentPadding(context),
                    itemCount: checklists.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: Config.xMargin(context, 50),
                    ),
                    crossAxisSpacing: Config.xMargin(context, 3),
                    mainAxisSpacing: Config.yMargin(context, 2),
                    itemBuilder: (context, index) {
                      final checklist = checklists[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(ChecklistScreen.route, extra: checklist);
                        },
                        child: Container(
                          padding: Config.contentPadding(context, h: 3, v: 1),
                          height: checklist.extent(context),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.6),
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Text(
                                checklist.title,
                                overflow: TextOverflow.ellipsis,
                                style: Config.h2(context),
                              ),
                              SizedBox(height: Config.yMargin(context, 1)),
                              ...checklist.undone
                                  .take(4)
                                  .map(
                                    (e) => CheckboxListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        e.text,
                                        style: Config.b1(context),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      value: false,
                                      onChanged: null,
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
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
