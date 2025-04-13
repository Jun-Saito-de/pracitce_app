import 'package:flutter/material.dart';
// 追加import
import 'dart:math';  // ランダムに駅を選ぶRandomクラスを使うため
import 'station.dart'; // 自分で定義したStationクラスを使うため
import 'station_loader.dart'; // JSONファイルを読み込む loadStations() 関数を使うため
import 'station_detail_page.dart'; // 詳細ページのファイルで定義されたクラスや関数を使用するため
// WantedListPage 「行きたい」一覧を使うため
import 'wanted_list_page.dart';



// アプリのどこからでもアクセスできるグローバル変数を設定
List<String> wantedStationNames = []; // 行きたい駅（駅名で管理する）
List<String> visitedStationNames = []; // 行った駅（駅名で管理する）

// アプリのエントリーポイント
void main() {
  runApp(const TokyoSubwayExplorerApp()); //TokyoSubwayExplorerApp() がアプリ全体のルートウィジェット。
}

// アプリ全体の構成（ルートウィジェット）
class TokyoSubwayExplorerApp extends StatelessWidget { // 状態を持たないUIの部品であるStatelessWidgetで構成されている
  const TokyoSubwayExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Flutterアプリの基本フレーム。ルートとなるナビゲーションやテーマなどをここで指定
      title: '東京の地下鉄探検',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 背景色を白に
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightGreenAccent, // AppBarの色
          foregroundColor: Colors.black, // タイトルやアイコンの色
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.lightGreenAccent, // 背景色
          selectedItemColor: Colors.black, // 選択中のアイコンの色
          unselectedItemColor: Colors.grey, // 選択していない方のアイコンの色
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(), // 最初に表示する画面を設定
    );
  }
}

// ホーム画面の土台（StatefulWidget）
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // createState() で実際の中身（_HomePageState）を返している
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//  ホーム画面の見た目と動き（_HomePageState）
class _MyHomePageState extends State<MyHomePage> {
  // _selectedIndex は BottomNavigationBar でどのタブを選んでるかを管理するための変数
  int _selectedIndex = 0;

  // stations.json を読み込んだときにできる、「すべての駅データ」を保存
  List<Station> _stations = [];
  // ボタンを押したときに、ランダムで選んだ駅1つを保存
  Station? _selectedStation;

  // initStateに読み込み処理を追加
  @override // 親クラスにある関数を上書きして使用
  void initState() { // initState()は、Widgetが最初に表示されるタイミングで一度だけ呼ばれる特別な関数
    super.initState(); // 親クラスの初期化も忘れずに呼ぶお約束
    // 先ほど作った JSON読み込み関数（非同期）を呼び出す
    loadStations().then((stations) { // 	読み込みが完了したあとに続けて実行する処理
      print("読み込んだ駅数: ${stations.length}"); // ← これを追加！
      setState(() { // 	状態が変わったことを Flutter に伝えてUIを更新！
        _stations = stations;
      });
    });
}

// 探索ページの中身を _buildMainPage() として独立
  Widget _buildMainPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _selectedStation?.name ?? '駅名が表示されるよ！',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 40),
          // 「詳細を見る」ボタンの追加
          if (_selectedStation != null) // _selectedStationがnullでなければ発動
            ElevatedButton(
              onPressed: (){ // 押されたら
                Navigator.push( // 新しいページに移動する処理
                  context,
                  MaterialPageRoute( // 	ページ遷移のためのルート（画面）を作る
                    builder: (context) => StationDetailPage(station: _selectedStation!), // StationDetailPageは、これから作る新しい詳細画面！
                  ),
                );
              },
              child: Text('詳細を見る'),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){
              // 駅名ランダム表示の処理
              if (_stations.isNotEmpty) { // 駅一覧がちゃんと読み込めてるか確認（空なら何もしない）
                final random = Random();
                // random.nextInt() →  ランダムなインデックスを生成（例：0〜199）
                final index = random.nextInt(_stations.length);
                setState(() { // setStateで状態を更新 → UIを再描画！
                  _selectedStation = _stations[index]; // _stations[index]はランダムに選んだ駅
                });
              }
            },
            child: Text('駅を探索する'),
          ),
        ],
      ),
    );
  }

  // _buildBody() という関数を新たに追加
  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return WantedListPage(); // 一覧ページ（行きたい駅）
    } else if (_selectedIndex == 1) {
      return _buildMainPage(); // 一覧ページ（行った駅）
    } else {
      return _buildMainPage(); // ホーム画面（駅を表示）);
    }
  }

  // メインUI（Scaffold）
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('東京の地下鉄探検',
          style: TextStyle(
            fontSize: 16,          // フォントサイズ
            fontWeight: FontWeight.w500, // 太字にするなら
          ),
        ),
        centerTitle: true, // タイトルを中央寄せ（Centerウィジェットで挟むよりこちらの方が良い！）
      ),
      // メインの中身
      body: _buildBody(),
      //  BottomNavigationBar（下のナビ）
      bottomNavigationBar: BottomNavigationBar( // BottomNavigationBar: アプリ下部のナビバー（画面切り替えやモード切り替えに使う）
        // currentIndex: 今選ばれてるタブの番号
          currentIndex: _selectedIndex,
          // onTap: タップされたときの動作。setState() で UI を更新
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              // 画面遷移は後で設定する
            });
          },
        // 文字スタイルの追加（どちらのアイコンもフォントサイズを均一に）
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border),
          label: '行きたい',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check_outlined),
            label: '行った',
          ),
        ],
      ),
    );
  }

}