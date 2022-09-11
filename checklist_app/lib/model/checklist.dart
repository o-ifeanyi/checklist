import 'dart:math';

import 'package:checklist_app/core/constants/constants.dart';
import 'package:checklist_app/core/util/config.dart';
import 'package:flutter/material.dart';

enum SyncAction { synched, create, delete, update }

class ChecklistModel {
  final String id;
  final String title;
  final SyncAction action;
  final DateTime updatedAt;
  final List<ChecklistItemModel> items;

  ChecklistModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.action = SyncAction.synched,
    required this.items,
  });

  List<ChecklistItemModel> get undone =>
      this.items.where((item) => !item.done).toList();

  List<ChecklistItemModel> get done =>
      this.items.where((item) => item.done).toList();

  double extent(BuildContext context) {
    final maxi = Config.yMargin(context, 30);
    final double e;
    switch (undone.length) {
      case 1:
        e = 1;
        break;
      case 2:
        e = 1.4;
        break;
      case 3:
        e = 1.8;
        break;
      case 4:
        e = 2.2;
        break;
      default:
        e = 0.6;
    }
    final extent = e * Config.textSize(context, 12);
    return min(maxi, extent);
  }

  ChecklistModel copyWith({
    String? title,
    SyncAction? action,
    List<ChecklistItemModel>? items,
    DateTime? updatedAt,
  }) {
    return ChecklistModel(
      id: id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      action: action ?? this.action,
      items: items ?? this.items,
    );
  }

  factory ChecklistModel.fromJson(Map json) {
    return ChecklistModel(
      id: json['id'],
      title: json['title'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      action: SyncAction.values.firstWhere(
        (action) => action.name == json['action'],
        orElse: () => SyncAction.synched,
      ),
      items: (json['items'] as List)
          .map((e) => ChecklistItemModel.fromJson(e))
          .toList(),
    );
  }

  JsonMap toMap() {
    return {
      'id': id,
      'title': title,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'action': action.name,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }
}

class ChecklistItemModel {
  final String text;
  final bool done;

  ChecklistItemModel({required this.text, required this.done});

  factory ChecklistItemModel.fromJson(Map json) {
    return ChecklistItemModel(
      text: json['text'],
      done: json['done'],
    );
  }

  JsonMap toMap() {
    return {
      'text': text,
      'done': done,
    };
  }
}
