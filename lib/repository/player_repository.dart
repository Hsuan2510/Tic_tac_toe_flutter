import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayerRepository {
  final String apiUrl = 'https://dart-leaderboard-rdchfzm4oa-ey.a.run.app/api/players';

  Future<List<Player>> fetchPlayers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }
}

class Player {
  final String id;
  final int wins;

  Player({required this.id, required this.wins});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      wins: json['score']
    );
  }
}
