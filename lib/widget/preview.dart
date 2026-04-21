import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> showPreview(BuildContext context, String image) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Vista previa'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Ok!')),
      ],
      content: Column(
        mainAxisSize: .min,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Image.asset(image),
            ),
          ),
        ],
      ),
    ),
  );
}
