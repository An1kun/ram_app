import 'package:flutter/material.dart';
import 'package:ram_app/model/location.dart';
import 'package:ram_app/network/rick_and_morty_api.dart';
import 'package:ram_app/presentation/main_page.dart';

class LocationTabController extends ChangeNotifier {
  LocationTabController(this.api);

  final RickAndMortyApi api;

  int page = 1;
  bool reachedMax = false;
  List<Location> locations = [];

  Future<void> loadMore() async {
    if (reachedMax) return;

    final result = await api.getLocations(page: page);
    locations.addAll(result.locations);
    reachedMax = result.reachedMax;
    page++;

    notifyListeners();
  }
}

class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  late final LocationTabController _locationTabController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleLoadMore);
  }

  void _handleLoadMore() {
    final position = _scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;

    if (position.pixels + 100 >= maxScrollExtent) {
      _locationTabController.loadMore();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locationTabController =
        LocationTabController(RickAndMortyApiProvider.of(context).api);

    _locationTabController.loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _locationTabController,
      builder: (_, child) => ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _locationTabController.locations.length,
        itemBuilder: (_, index) {
          final location = _locationTabController.locations[index];

          return LocationCard(location: location);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16);
        },
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location.name),
            Text(location.dimension),
          ],
        ),
      ),
    );
  }
}
