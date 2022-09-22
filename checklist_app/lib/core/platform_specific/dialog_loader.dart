import 'package:checklist_app/core/util/config.dart';
import 'package:flutter/material.dart';

import 'platform_alert_dialog.dart';
import 'platform_progress_indicator.dart';

class DialogLoader<T> extends StatelessWidget {
  final Future<T> function;
  const DialogLoader({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: function,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Navigator.pop(context, snapshot.data);
        }
        return PlatformAlertDialog(
          content: Padding(
            padding: Config.contentPadding(context, v: 3),
            child: const PlatformProgressIndicator(),
          ),
          actions: [],
        );
      },
    );
  }
}
