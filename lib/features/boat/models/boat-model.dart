import 'package:flutter/material.dart';

class ItemModel {
  bool expanded;
  String headerItem;
  String description;
  Color colorsItem;
  String img;

  ItemModel({
    this.expanded: false,
    this.headerItem,
    this.description,
    this.colorsItem,
    this.img,
  });
}
