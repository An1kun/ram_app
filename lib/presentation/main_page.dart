import 'package:flutter/material.dart';
import 'package:ram_app/network/rick_and_morty_api.dart';
import 'package:ram_app/presentation/app.dart';
import 'package:ram_app/presentation/character_tab.dart';
import 'package:ram_app/presentation/episode_tab.dart';
import 'package:ram_app/presentation/location_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            value: AppThemeProvider.of(context).appTheme.isDarkTheme,
            onChanged: (value) {
              AppThemeProvider.of(context).appTheme.toggleTheme(value);
            },
          ),
        ],
        title: const Text('Rick and Morty App'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
            ),
            Tab(
              icon: Icon(Icons.location_city),
            ),
            Tab(
              icon: Icon(Icons.tv),
            )
          ],
        ),
      ),
      body: RickAndMortyApiProvider(
        api: const RickAndMortyApi(),
        child: TabBarView(
          controller: _tabController,
          children: const [
            CharacterTab(),
            LocationTab(),
            EpisodeTab(),
          ],
        ),
      ),
    );
  }
}

class RickAndMortyApiProvider extends InheritedWidget {
  const RickAndMortyApiProvider({
    super.key,
    required super.child,
    required this.api,
  });

  final RickAndMortyApi api;

  @override
  bool updateShouldNotify(covariant RickAndMortyApiProvider oldWidget) {
    return false;
  }

  static RickAndMortyApiProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RickAndMortyApiProvider>();
  }

  static RickAndMortyApiProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No RickAndMortyApiProvider found in context');
    return result!;
  }
}
