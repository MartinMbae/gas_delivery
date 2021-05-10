import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_delivery/utils/constants.dart';

class SelectOption {
  final String title;
  final String description;
  final String image_icon;
  final SELECT_OPTIONS_ITEMS select_options_items;
  final String buttonText;

  SelectOption({
    required this.title,
    required this.description,
    required this.image_icon,
    required this.select_options_items,
    required this.buttonText,
  });
}

final selectOptionsList = [
  SelectOption(
      title: 'New Purchase',
      description: 'New customer purchasing a gas cylinder or its accessories',
      image_icon: 'assets/gas_accesories.jpg',
      select_options_items: SELECT_OPTIONS_ITEMS.NEW_PURCHASE,
      buttonText: 'Add New Purchase'),
  SelectOption(
      title: 'Refilling',
      description: 'Customer wishing to refill their gas cylinders',
      image_icon: 'assets/gas_refill.jpg',
      select_options_items: SELECT_OPTIONS_ITEMS.REFILL,
      buttonText: 'Refill Now'),
];
