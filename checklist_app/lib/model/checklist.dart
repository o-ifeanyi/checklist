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

  @override
  bool operator ==(Object other) {
    if (other is! ChecklistModel) return false;
    return this.id == other.id;
  }

  List<ChecklistItemModel> get undone =>
      this.items.where((item) => !item.done).toList();

  List<ChecklistItemModel> get done =>
      this.items.where((item) => item.done).toList();

  double extent(BuildContext context) {
    final maxi = Config.yMargin(context, 30);
    final double e;
    switch (undone.length) {
      case 0:
        e = 0.6;
        break;
      case 1:
        e = 1;
        break;
      case 2:
        e = 1.4;
        break;
      case 3:
        e = 1.8;
        break;
      default:
        e = 2.2;
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
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
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
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'action': action.name,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }
}

class ChecklistItemModel {
  final String id;
  final String text;
  final bool done;

  ChecklistItemModel(
      {required this.id, required this.text, required this.done});

  @override
  bool operator ==(Object other) {
    if (other is! ChecklistItemModel) return false;
    return this.id == other.id;
  }

  factory ChecklistItemModel.fromJson(Map json) {
    return ChecklistItemModel(
      id: json['id'],
      text: json['text'],
      done: json['done'],
    );
  }

  ChecklistItemModel copyWith({String? text, bool? done}) {
    return ChecklistItemModel(
      id: id,
      text: text ?? this.text,
      done: done ?? this.done,
    );
  }

  JsonMap toMap() {
    return {
      'id': id,
      'text': text,
      'done': done,
    };
  }
}
