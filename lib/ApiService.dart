import 'Deck.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Card.dart';

class ApiService {
  static final ApiService _apiService = ApiService._internal();

  factory ApiService() {
    return _apiService;
  }

  ApiService._internal();

  Future<List<Deck>> fetchDecks() async {
    final response = await http.get('https://pgbg.herokuapp.com/decks');

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => Deck.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load decks');
    }
  }

  Future<Card> draw(String deck) async {
    final response =
        await http.post('https://pgbg.herokuapp.com/game/draw?deck=$deck');

    if (response.statusCode == 200) {
      return Card.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load card');
    }
  }
}
