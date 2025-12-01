// lib/core/adaptive.dart
import 'package:flutter/widgets.dart';

bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 900;
bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 900;
