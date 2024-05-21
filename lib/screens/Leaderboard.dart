import 'package:flutter/material.dart';
import 'package:tic_tac_toe/repository/player_repository.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final PlayerRepository _playerRepository = PlayerRepository();
  late Future<List<Player>> _futurePlayers;

  @override
  void initState() {
    super.initState();
    _futurePlayers = _playerRepository.fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), // 设置背景图像
            fit: BoxFit.cover, // 让图像铺满整个容器
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60), // 顶部间距
            Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20), // 标题和列表之间的间距
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // 半透明背景，使文字更清晰
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder<List<Player>>(
                    future: _futurePlayers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
                      } else {
                        // 对玩家列表按照获胜次数降序排序
                        List<Player> sortedPlayers = snapshot.data!;
                        sortedPlayers.sort((a, b) => b.wins.compareTo(a.wins));
                        return _buildPlayerList(sortedPlayers);
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 60), // 底部间距
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerList(List<Player> players) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white.withOpacity(0.3), // 半透明卡片背景
          child: ListTile(
            leading: Text(
              '${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ), // 显示排名索引
            title: Text(
              players[index].id,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            subtitle: Text(
              '${players[index].wins} wins',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
