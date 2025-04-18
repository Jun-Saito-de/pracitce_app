// JSONから読み込んだデータを、Dartで扱いやすくするための**クラス（型）**を、station.dart内で作ります
class Station {
  // クラス（駅）が持つデータ（プロパティ）を定義
  final String name; // 駅名
  final String kana; // 駅名ひらがな
  final String romaji; // 駅名ローマ字
  final List<String> numbering; // 駅ナンバリング
  final List<String> lines; // 駅の路線名
  final String location; // 駅の所在地
  // String? → null を許容する文字列（豆知識が未入力でもOKにする）
  final String? funFact; // 駅の豆知識
  // クラスの中身（Station）を作るために、「コンストラクタ」という"初期化の仕組み"を使う
  Station({
    // required this.name	は、外から name を必ず渡してね、という意味
    required this.name,
    required this.kana,
    required this.romaji,
    required this.numbering,
    required this.lines,
    required this.location,
    this.funFact, // optional（省略可能）
  });
  // fromJson() を Station クラスに追加
  // factory →  クラスのインスタンス（Station）をカスタムルールで作る関数
  // Map<String, dynamic> →  JSONの1件分のデータ（例：駅名や路線など）
  factory Station.fromJson(Map<String,dynamic> json) {
    return Station(
      // json['駅名'] →  JSONの中の「駅名」というキーの値を取り出す
      name: json['name'],
      kana: json['kana'],
      romaji: json['romaji'],
      numbering: List<String>.from(json['numbering']),
      lines: List<String>.from(json['lines']),
      location: json['location'],
      funFact: json['funFact'],
    );
  }
}