import 'package:flutter/material.dart';
import 'package:green_genie/config/theme.dart';
import 'package:green_genie/data/has_value.dart';

Widget customDropdown<T extends HasValue>({
  required String labelText,
  required List<T> items,
  required T? value,
  required void Function(T?) onChanged,
  required double width,
  required double height,
}) =>
    Expanded(
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText, style: label()),
          SizedBox(
            width: width,
            height: height * 0.06,
            child: DropdownButtonFormField<T>(
              value: value,
              items: items
                  .map((item) =>
                      DropdownMenuItem<T>(value: item, child: Text(item.value)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
