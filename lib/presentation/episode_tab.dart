import 'package:flutter/material.dart';
import 'package:ram_app/model/episode.dart';
import 'package:ram_app/network/rick_and_morty_api.dart';
import 'package:ram_app/presentation/main_page.dart';

class EpisodeTabController extends ChangeNotifier {
  EpisodeTabController(this.api);

  final RickAndMortyApi api;

  int page = 1;
  bool reachedMax = false;
  List<Episode> episodes = [];

  Future<void> loadMore() async {
    if (reachedMax) return;

    final result = await api.getEpisodes(page: page);
    episodes.addAll(result.episodes);
    reachedMax = result.reachedMax;
    page++;

    notifyListeners();
  }
}

class EpisodeTab extends StatefulWidget {
  const EpisodeTab({super.key});

  @override
  State<EpisodeTab> createState() => _EpisodeTabState();
}

class _EpisodeTabState extends State<EpisodeTab> {
  late final EpisodeTabController _episodeTabController;
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
      _episodeTabController.loadMore();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _episodeTabController =
        EpisodeTabController(RickAndMortyApiProvider.of(context).api);

    _episodeTabController.loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _episodeTabController,
      builder: (_, child) => ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _episodeTabController.episodes.length,
        itemBuilder: (_, index) {
          final episode = _episodeTabController.episodes[index];

          return EpisodeCard(episode: episode);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16);
        },
      ),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  const EpisodeCard({super.key, required this.episode});

  final Episode episode;

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
            Text(episode.name),
            Text(episode.airDate),
          ],
        ),
      ),
    );
  }
}
