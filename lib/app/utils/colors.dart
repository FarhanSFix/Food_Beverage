import 'package:flutter/material.dart';

Color getColor(String jenis) {
  if (jenis == "Makanan") {
    return Colors.orange;
  } else if (jenis == "Minuman") {
    return const Color(0xFF00B4D8);
  } else {
    return Colors.red;
  }
}
