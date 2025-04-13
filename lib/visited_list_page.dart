import 'package:flutter/material.dart';
import 'package:flutter_metro_practice/main.dart';
import 'station.dart'; // Station クラス（駅のデータ構造）を使うため
import 'station_loader.dart'; // loadStations() や findStationByName() を使うため
import 'station_detail_page.dart'; // 画面遷移で StationDetailPage を表示するため

// 「行った駅」のクラスを作成
class VisitedListPage extends StatefulWidget {
  const VisitedListPage({super.key});

  @override
  State<VisitedListPage> createState() => _VisitedListPageState();
}

class _VisitedListPageState extends State<VisitedListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行った駅リスト'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: visitedStationNames.length, // ← ここ！
              itemBuilder: (context, index) {
                final stationName = visitedStationNames[index]; // ← ここも！
                return ListTile(
                  title: Text(stationName),
                  trailing: TextButton(
                    onPressed: () {
                      setState(() {
                        visitedStationNames.remove(stationName); // ← ここも！
                      });
                    },
                    child: Text('削除'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
