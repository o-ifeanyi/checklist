import 'package:checklist_app/core/services/snackbar_service.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:checklist_app/core/util/themes.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final SnackbarModel snackbarModel;
  final void Function() onDismiss;

  const CustomSnackBar({
    Key? key,
    required this.snackbarModel,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: (_) => onDismiss(),
        child: Container(
          padding: Config.contentPadding(context, h: 5, v: 2),
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: snackbarModel.status == Status.success
                ? kGreenAccent
                : Theme.of(context).errorColor,
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snackbarModel.title != null)
                  Text(
                    snackbarModel.title!,
                    style: Config.b1b(context).copyWith(color: Colors.white),
                  ),
                Text(
                  snackbarModel.message,
                  style: Config.b1(context).copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
