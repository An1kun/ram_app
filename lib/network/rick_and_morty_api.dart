import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ram_app/model/character.dart';
import 'package:ram_app/model/episode.dart';
import 'package:ram_app/model/location.dart';

class RickAndMortyApi {
  const RickAndMortyApi();

  final _endpoint = 'https://rickandmortyapi.com/api';

  Future<({List<Character> characters, bool reachedMax})> getCharacters({
    required int page,
  }) async {
    final uri = Uri.parse('$_endpoint/character?page=$page');

    final response = await http.get(uri);

    final body = jsonDecode(response.body);

    final characters =
        (body['results'] as List).map((e) => Character.fromJson(e)).toList();

    final reachedMax = body['info']['pages'] == page;

    return (characters: characters, reachedMax: reachedMax);
  }

  Future<({List<Location> locations, bool reachedMax})> getLocations({
    required int page,
  }) async {
    final uri = Uri.parse('$_endpoint/location?page=$page');

    final response = await http.get(uri);

    final body = jsonDecode(response.body);

    final locations =
        (body['results'] as List).map((e) => Location.fromJson(e)).toList();

    final reachedMax = body['info']['pages'] == page;

    return (locations: locations, reachedMax: reachedMax);
  }

  Future<({List<Episode> episodes, bool reachedMax})> getEpisodes({
    required int page,
  }) async {
    final uri = Uri.parse('$_endpoint/episode?page=$page');

    final response = await http.get(uri);

    final body = jsonDecode(response.body);

    final episodes =
        (body['results'] as List).map((e) => Episode.fromJson(e)).toList();

    final reachedMax = body['info']['pages'] == page;

    return (episodes: episodes, reachedMax: reachedMax);
  }
}
