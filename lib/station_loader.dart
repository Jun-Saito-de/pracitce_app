import 'dart:convert'; // JSON文字列を扱うためのライブラリ
import 'package:flutter/services.dart'; // assets（stations.jsonなど）読み込み用
import 'station.dart'; // 自分で作ったStationクラスを使うためのもの

// 駅名からStationを探す関数の追加
Future<Station?> findStationByName(String name) async {
  final stations = await loadStations();
  try {
    return stations.firstWhere((station) => station.name == name);
  } catch (e) {
    return null; // 見つからなかった場合は null を返す
  }
}
// Future<> →  「将来的にデータを返す」とぃう非同期処理（読み込みが終わるまで待つ）
// List<Station> →  戻り値はStationクラスのリスト
Future<List<Station>> loadStations() async {
  // await →  読み込みが終わるまで待ってという合図
  // rootBundle →  assets（= JSONファイル）から文字列を読み込む命令
  // final String jsonString → 読み込んだ結果（JSONの中身）を文字列として保存する
  final String jsonString = await rootBundle.loadString('assets/stations.json');
  // jsonStringを、Dartのリストやマップとして使える形に変換
  final List<dynamic> jsonList = json.decode(jsonString);
  // mapでJSONの1件ずつに対して処理をループで行う。
  // Station.fromjson(json) →  1つのjsonオブジェクトをStationに変換
  // .toList() →  最後にリストとしてまとめる
  return jsonList.map((json) => Station.fromJson(json)).toList();
}