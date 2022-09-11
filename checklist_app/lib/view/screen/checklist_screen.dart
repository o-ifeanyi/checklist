import 'package:checklist_app/core/platform_specific/platform_icons.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/model/checklist.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChecklistScreen extends StatefulWidget {
  static const String route = '/checklist';
  const ChecklistScreen({super.key, this.checklist});

  final ChecklistModel? checklist;

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late ChecklistModel checklist;
  late bool isUpdate;
  @override
  void initState() {
    super.initState();
    isUpdate = widget.checklist != null;
    if (isUpdate) {
      checklist = widget.checklist!;
    } else {
      checklist = ChecklistModel(
        id: const Uuid().v4(),
        title: 'title',
        updatedAt: DateTime.now(),
        items: [ChecklistItemModel(text: '', done: false)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ChecklistProvider>();
    return WillPopScope(
      onWillPop: () {
        if (isUpdate)
          provider.update(checklist);
        else
          provider.create(checklist);

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: Config.contentPadding(context),
          child: Column(
            children: [
              TextFormField(
                initialValue: checklist.title,
                style: Config.h2(context),
                decoration: InputDecoration(
                  errorStyle: Config.b2(context),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (val) {},
              ),
              ...checklist.undone
                  .map(
                    (e) => CheckboxListTile(
                      key: ValueKey(e.hashCode),
                      contentPadding: const EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: TextFormField(
                        initialValue: e.text,
                        style: Config.b1(context),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: () {
                              final items = checklist.items..remove(e);
                              checklist = checklist.copyWith(items: items);
                              setState(() {});
                            },
                            icon: Icon(AppIcons.clear, size: 20),
                          ),
                        ),
                        onChanged: (val) {},
                      ),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: e.done,
                      onChanged: (val) {
                        if (val == null) return;
                        final items = checklist.items;
                        final index = items.indexOf(e);
                        items.replaceRange(index, index + 1,
                            [ChecklistItemModel(text: e.text, done: val)]);
                        checklist = checklist.copyWith(items: items);
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
              ListTile(
                onTap: () {
                  final items = checklist.items;
                  items.add(ChecklistItemModel(text: '', done: false));
                  checklist = checklist.copyWith(items: items);
                  setState(() {});
                },
                leading: Icon(AppIcons.add),
                title: Text(
                  'Add item',
                  style: Config.b1(context),
                ),
              ),
              if (checklist.done.isNotEmpty) ...[
                const Divider(thickness: 1),
                ...checklist.done
                    .map(
                      (e) => CheckboxListTile(
                        key: ValueKey(e.hashCode),
                        activeColor: Theme.of(context).backgroundColor,
                        contentPadding: const EdgeInsets.all(0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          e.text,
                          style: Config.b1(context).copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: e.done,
                        onChanged: (val) {
                          if (val == null) return;
                          final items = checklist.items;
                          final index = items.indexOf(e);
                          items.remove(e);
                          items.insert(index,
                              ChecklistItemModel(text: e.text, done: val));
                          checklist = checklist.copyWith(items: items);
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
