import 'package:flutter/material.dart';
import 'package:flutter_metro_practice/main.dart';
import 'station.dart'; // 駅の情報を受け取るために必要！

// StationDetailPage →  詳細ページのWidget
class StationDetailPage extends StatelessWidget {
  // ランダム表示された駅の情報を受け取る変数
  final Station station;

  const StationDetailPage({
    super.key,
    required this.station,
  }); // required this station →  Navigatorから受け取った情報をここにセット

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 上部タイトルに駅名を表示
        title: Text('${station.name}駅',
          style: TextStyle(
          fontSize: 16,          // フォントサイズ
        ),
      ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${station.name}', style: TextStyle(fontSize: 28)),
            SizedBox(height: 8),
            Text('${station.hiragana}', style: TextStyle(fontSize: 16)),
            Text('${station.romaji}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              '${station.numbering}',
              style: TextStyle(fontSize: 16),
            ),
            Text('${station.line}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('（${station.location}）', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            if (station.funFact != null)
              Text('${station.funFact}', style: TextStyle(fontSize: 16)),
            // 詳細ページに「行きたい」「行った」ボタンを追加
            SizedBox(height: 24), // サイズ調整のスペーサー
            // 横並びでボタンを設置
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final name = station.name; // 押したら駅名を取得

                    //「行きたい」に登録する処理
                    if (wantedStationNames.contains(name)) {
                      // 「行きたい」に駅名が登録されていたら
                      wantedStationNames.remove(name); // 登録解除する
                    } else {
                      // そうでなければ
                      wantedStationNames.add(name); // 登録
                      visitedStationNames.remove(name); // 「行った」からは削除
                    }
                  },
                  // 「行きたい」ボタンのアイコン
                  icon: Icon(
                    wantedStationNames.contains(station.name)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  // ボタンのテキスト部分をlabelで設定
                  label: Text('行きたい！'),
                ),
                SizedBox(width: 16), // スペーサー
                // 「行った」ボタン
                ElevatedButton.icon(
                  onPressed: () {
                    final name = station.name;

                    //「行った」に登録する処理
                    if (visitedStationNames.contains(name)) {
                      // 「行った」に駅名が登録されていたら
                      visitedStationNames.remove(name); // 登録解除する
                    } else {
                      // そうでなければ
                      visitedStationNames.add(name); // 登録
                      wantedStationNames.remove(name); // 「行きたい」からは削除
                    }
                  },
                  // 「行った」ボタンのアイコン
                  icon: Icon(
                    visitedStationNames.contains(station.name)
                        ? Icons.check
                        : Icons.check_circle_outline,
                  ),
                  // ボタンのテキスト部分をlabelで設定
                  label: Text('行った！'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
