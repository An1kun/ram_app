import 'package:flutter/material.dart';
import 'package:ram_app/presentation/app_theme.dart';
import 'package:ram_app/presentation/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeProvider.of(context).appTheme,
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppThemeProvider.of(context).appTheme.theme,
        // ignore: prefer_const_constructors
        home: MainPage(),
      ),
    );
  }
}

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({
    super.key,
    required Widget child,
    required this.appTheme,
  }) : super(child: child);

  final AppTheme appTheme;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static AppThemeProvider? maybeOf(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    return result;
  }

  static AppThemeProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No AppThemeProvider found in context');
    return result!;
  }
}
