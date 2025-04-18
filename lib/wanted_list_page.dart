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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: wantedStationNames.length,
              itemBuilder: (context, index) {
                final stationName = wantedStationNames[index];
                return ListTile(
                  title: Text(stationName),
                  trailing: TextButton(
                    onPressed: () {
                      setState(() {
                        wantedStationNames.remove(stationName);
                      });
                    },
                    child: Text('削除'),
                  ),
                );
              },
            ),
          ),
        ],
      )

    );
  }
}

