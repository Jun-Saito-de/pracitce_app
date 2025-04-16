import 'package:flutter/material.dart';
import 'package:flutter_metro_practice/main.dart';
import 'station.dart'; // 駅の情報を受け取るために必要！

// 路線のカラー定義とヘルパー関数を追加
final Map<String, Color> lineColors = {
  '銀座線': Color(0xFFFF9500),
  '丸ノ内線': Color(0xFFF62E36),
  '日比谷線': Color(0xFFB5B5AC),
  '東西線': Color(0xFF009BBF),
  '千代田線': Color(0xFF00BB85),
  '有楽町線': Color(0xFFC1A470),
  '半蔵門線': Color(0xFF8F76D6),
  '南北線': Color(0xFF00AC9B),
  '副都心線': Color(0xFF9C5E31),
  '浅草線': Color(0xFFE85298),
  '三田線': Color(0xFF0079C2),
  '新宿線': Color(0xFF6CBB5A),
  '大江戸線': Color(0xFFB6007A),
};

// 路線名を渡すと、対応する色を返す関数（ヘルパー関数）
Color getLineColor(String fullLineName) { // fullLineName は "東京メトロ銀座線" や "都営大江戸線" のような長い名前
  final cleanName = fullLineName
  // .replaceAll() を使って不要な部分を消して、 "銀座線" などに整えます
  // .replaceAll(A, B)→ AをBに変換
  // カラー定義は銀座線のように略称のため
      .replaceAll('東京メトロ', '')
      .replaceAll('都営', '');
  return lineColors[cleanName] ?? Colors.grey;
}

Widget buildLineChips(BuildContext context, Station station) {
  // 背景色の色をbgColorに代入
  final bgColor = Theme.of(context).scaffoldBackgroundColor;

  return Wrap(
    spacing: 12,
    runSpacing: 8,
    children: List.generate(station.lines.length, (index) {
      final line = station.lines[index];
      final number = station.numbering[index];
      final color = getLineColor(line);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ドーナッツ型アイコン
          Stack(
            alignment: Alignment.center,
            children: [
              // 外側の丸（路線のカラー）
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              //内側の丸（背景色）
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(width: 6),
          Text(
            number,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight
            .bold),
          ),
        ],
      );
    })
  );
}

// StationDetailPage →  詳細ページのWidget
class StationDetailPage extends StatefulWidget {
  // ランダム表示された駅の情報を受け取る変数
  final Station station;

  const StationDetailPage({
    super.key,
    required this.station,
  }); // required this station →  Navigatorから受け取った情報をここにセット
  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}
 class _StationDetailPageState extends State<StationDetailPage> {

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
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
            Text('${station.kana}', style: TextStyle(fontSize: 16)),
            Text('${station.romaji}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            buildLineChips(context, station), // ← ★ここがチップ表示！
            SizedBox(height: 16),
            Text('${station.lines.join('、')}', style: TextStyle(fontSize: 16)),
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
                    setState(() {
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
                    });
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
                    setState(() {
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
                    });
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
