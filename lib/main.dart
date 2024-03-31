import 'package:flutter/widgets.dart';
import 'package:ram_app/presentation/app.dart';
import 'package:ram_app/presentation/app_theme.dart';

void main() {
  runApp(
    AppThemeProvider(
      appTheme: AppTheme(),
      child: const App(),
    ),
  );
}
