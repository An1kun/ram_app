import 'package:flutter/material.dart';
import 'package:ram_app/model/character.dart';
import 'package:ram_app/network/rick_and_morty_api.dart';
import 'package:ram_app/presentation/main_page.dart';

class CharacterTabController extends ChangeNotifier {
  CharacterTabController(this.api);

  final RickAndMortyApi api;

  int page = 1;
  bool reachedMax = false;
  List<Character> characters = [];

  Future<void> loadMore() async {
    if (reachedMax) return;

    final result = await api.getCharacters(page: page);
    characters.addAll(result.characters);
    reachedMax = result.reachedMax;
    page++;

    notifyListeners();
  }
}

class CharacterTab extends StatefulWidget {
  const CharacterTab({super.key});

  @override
  State<CharacterTab> createState() => _CharacterTabState();
}

class _CharacterTabState extends State<CharacterTab> {
  late final CharacterTabController _characterTabController;
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
      _characterTabController.loadMore();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _characterTabController =
        CharacterTabController(RickAndMortyApiProvider.of(context).api);

    _characterTabController.loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _characterTabController,
      builder: (_, child) => ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _characterTabController.characters.length,
        itemBuilder: (_, index) {
          final character = _characterTabController.characters[index];

          return CharacterCard(character: character);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16);
        },
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(
              character.image,
              width: 128,
              height: 128,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(character.name),
                Text(character.status),
                Text(character.species),
                Text(character.type),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
