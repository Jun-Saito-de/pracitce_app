import 'package:flutter/material.dart';
import 'package:flutter_metro_practice/main.dart';
import 'station.dart'; // Station クラス（駅のデータ構造）を使うため
import 'station_loader.dart'; // loadStations() や findStationByName() を使うため
import 'station_detail_page.dart'; // 画面遷移で StationDetailPage を表示するため

// 「行きたい駅」のクラスを作成
class WantedListPage extends StatefulWidget {
  const WantedListPage({super.key});

  @override
  State<WantedListPage> createState() => _WantedListPageState();
}

class _WantedListPageState extends State<WantedListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行きたい駅リスト'),
        centerTitle: true,
      ),
      body: ListView.builder( // 駅名リストを縦にスクロール表示
          itemCount: wantedStationNames.length,
          itemBuilder: (context,index){
            final stationName = wantedStationNames[index]; // 現在登録されている駅名を1件ずつ表示

            return ListTile( // 	行に駅名 + 削除ボタンを表示
              title: Text(stationName), // 表示される駅名（タップ可能）
              // ListTile がタップされたときの処理を定義
              onTap: () async { // この onTap: は ListTile に付けられるプロパティで、その行をタップしたときに実行する動作
                final station = await findStationByName(stationName); // 駅名からStationを探す
                // Stationが見つかれば詳細ページに遷移！
                if (station != null) { // 見つかったときだけ動作
                  Navigator.push( // 新しいページに画面遷移する命令
                    context,
                    MaterialPageRoute(
                      builder: (context) => StationDetailPage(station: station), // 詳細ページに、取得した駅データを渡す
                    ),
                  );
                }
              },
              trailing: TextButton( // 削除処理（今はメモリ内だけ）
                  onPressed: () {
                    setState((){
                      wantedStationNames.remove(stationName);
                    });
                  },
                  child: Text('削除'),
              ),
            );
          },
      ),
    );
  }
}

