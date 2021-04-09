import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(TokutenApp());

class TokutenApp extends StatelessWidget {
  @override
  Widget build(BuildContext content) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: [Locale('ja', 'JP')],
      title: '得点差計算機',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: TokutenCalc(),
    );
  }
}

class TokutenCalc extends StatefulWidget {
  @override
  _TokutenCalcState createState() => _TokutenCalcState();
}

class _TokutenCalcState extends State<TokutenCalc> {
  //自分の持ち点
  var myTokuten = TextEditingController();
  //相手の持ち点
  var yourTokuten = TextEditingController();
  //相手との直撃条件のテキスト
  var textDirect = "";
  //相手とのツモ条件のテキスト
  var textTsumo = "";
  //相手との出アガリを満たす翻
  var textOther = "";
  //親スイッチ用変数
  var mySwitchValue = true;
  var yourSwitchValue = false;

  //逆転条件計算
  void calcTokuten() {
    //得点計算はListで書くより点数の公式からやったほうが早い?
    //多分ソース上はスリムになりそう
    setState(() {
      //自分と相手の点差
      int _diffTokuten =
          int.parse(yourTokuten.text) - int.parse(myTokuten.text);
      //最小条件を出すための変数
      int _minDirectDiff = 48000;
      int _minTsumoDiff = 48000;
      int _minOtherDiff = 48000;

      //子の点数リスト
      List<List<int>> childTokutenList = [
        [1000, 2000, 3900],
        [1300, 2600, 5200],
        [1600, 3200, 6400]
      ];

      //子対子のツモ時点棒の変動リスト
      List<List<int>> childTsumoList = [
        [1400, 2500, 5000],
        [1900, 3400, 6500],
        [2000, 4000, 8000]
      ];

      //親の点数リスト
      List<List<int>> parentTokutenList = [
        [1500, 2900, 5800],
        [2000, 3900, 7700],
        [2400, 4800, 9600]
      ];

      //子対親のツモ時点棒の変動リスト
      List<List<int>> parentTsumoList = [
        [2000, 4000, 8000],
        [2800, 5200, 10400],
        [3200, 6400, 12800]
      ];

      //親のツモられ時点棒の変動リスト
      List<List<int>> oyakaburiList = [
        [1600, 3000, 6000],
        [2200, 4000, 7800],
        [2400, 4800, 9600]
      ];

      //表示の初期化
      textDirect = "";
      textOther = "";
      textTsumo = "";

      for (int i = 0; i < parentTokutenList.length; i++) {
        for (int j = 0; j < parentTokutenList[i].length; j++) {
          //自分が親だったら
          if (mySwitchValue) {
            //出アガリ条件を満たしたら
            if ((_diffTokuten <= parentTokutenList[i][j]) &&
                (parentTokutenList[i][j] < _minOtherDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minOtherDiff = parentTokutenList[i][j];
              textOther = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  parentTokutenList[i][j].toString() +
                  "点";
              //満貫以上の横移動の計算
            } else if (9600 < _diffTokuten) {
              if (_diffTokuten <= 12000) {
                textOther = "満貫";
              } else if (_diffTokuten <= 18000) {
                textOther = "跳満";
              } else if (_diffTokuten <= 24000) {
                textOther = "倍満";
              } else if (_diffTokuten <= 36000) {
                textOther = "三倍満";
              } else if (_diffTokuten <= 48000) {
                textOther = "役満";
              } else {
                textOther = "無し";
              }
            }

            //直撃条件を満たしたら
            if ((_diffTokuten / 2 <= parentTokutenList[i][j]) &&
                (parentTokutenList[i][j] < _minDirectDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minDirectDiff = parentTokutenList[i][j];
              textDirect = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  parentTokutenList[i][j].toString() +
                  "点";
              //満貫以上の直撃条件の計算
            } else if (19200 < _diffTokuten) {
              if (_diffTokuten <= 24000) {
                textDirect = "満貫";
              } else if (_diffTokuten <= 36000) {
                textDirect = "跳満";
              } else if (_diffTokuten <= 48000) {
                textDirect = "倍満";
              } else if (_diffTokuten <= 72000) {
                textDirect = "三倍満";
              } else if (_diffTokuten <= 96000) {
                textDirect = "役満";
              } else {
                textDirect = "無し";
              }
            }
            //ツモ条件を満たしたら
            if ((_diffTokuten <= parentTsumoList[i][j]) &&
                (parentTsumoList[i][j] < _minTsumoDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minTsumoDiff = parentTokutenList[i][j];
              textTsumo = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  parentTokutenList[i][j].toString() +
                  "点";
              //満貫以上のツモ条件
            } else if (19200 < _diffTokuten) {
              if (_diffTokuten <= 16000) {
                textTsumo = "満貫";
              } else if (_diffTokuten <= 24000) {
                textTsumo = "跳満";
              } else if (_diffTokuten <= 32000) {
                textTsumo = "倍満";
              } else if (_diffTokuten <= 48000) {
                textTsumo = "三倍満";
              } else if (_diffTokuten <= 64000) {
                textTsumo = "役満";
              } else {
                textTsumo = "無し";
              }
            }

            //相手が親だったら
          } else if (yourSwitchValue) {
            //出アガリ条件を満たしたら
            if ((_diffTokuten <= childTokutenList[i][j]) &&
                (childTokutenList[i][j] < _minOtherDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minOtherDiff = childTokutenList[i][j];
              textOther = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  childTokutenList[i][j].toString() +
                  "点";
            } else if (6400 < _diffTokuten) {
              if (_diffTokuten <= 8000) {
                textOther = "満貫";
              } else if (_diffTokuten <= 12000) {
                textOther = "跳満";
              } else if (_diffTokuten <= 16000) {
                textOther = "倍満";
              } else if (_diffTokuten <= 24000) {
                textOther = "三倍満";
              } else if (_diffTokuten <= 32000) {
                textOther = "役満";
              } else {
                textOther = "無し";
              }
            }
            //直撃条件を満たしたら
            if ((_diffTokuten / 2 <= childTokutenList[i][j]) &&
                (childTokutenList[i][j] < _minDirectDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minDirectDiff = childTokutenList[i][j];
              textDirect = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  childTokutenList[i][j].toString() +
                  "点";
            } else if (12800 < _diffTokuten) {
              if (_diffTokuten <= 16000) {
                textDirect = "満貫";
              } else if (_diffTokuten <= 24000) {
                textDirect = "跳満";
              } else if (_diffTokuten <= 32000) {
                textDirect = "倍満";
              } else if (_diffTokuten <= 48000) {
                textDirect = "三倍満";
              } else if (_diffTokuten <= 64000) {
                textDirect = "役満";
              } else {
                textDirect = "無し";
              }
            }
            //ツモ条件を満たしたら
            if ((_diffTokuten <= oyakaburiList[i][j]) &&
                (oyakaburiList[i][j] < _minTsumoDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minTsumoDiff = oyakaburiList[i][j];
              textTsumo = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  childTokutenList[i][j].toString() +
                  "点";
            } else if (9600 < _diffTokuten) {
              if (_diffTokuten <= 12000) {
                textTsumo = "満貫";
              } else if (_diffTokuten <= 18000) {
                textTsumo = "跳満";
              } else if (_diffTokuten <= 24000) {
                textTsumo = "倍満";
              } else if (_diffTokuten <= 36000) {
                textTsumo = "三倍満";
              } else if (_diffTokuten <= 48000) {
                textTsumo = "役満";
              } else {
                textTsumo = "無し";
              }
            }

            //子対子だったら
          } else {
            //出アガリ条件を満たしたら
            if ((_diffTokuten <= childTokutenList[i][j]) &&
                (childTokutenList[i][j] < _minOtherDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minOtherDiff = childTokutenList[i][j];
              textOther = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  childTokutenList[i][j].toString() +
                  "点";
            } else if (6400 < _diffTokuten) {
              if (_diffTokuten <= 8000) {
                textOther = "満貫";
              } else if (_diffTokuten <= 12000) {
                textOther = "跳満";
              } else if (_diffTokuten <= 16000) {
                textOther = "倍満";
              } else if (_diffTokuten <= 24000) {
                textOther = "三倍満";
              } else if (_diffTokuten <= 32000) {
                textOther = "役満";
              } else {
                textOther = "無し";
              }
            }
            //直撃条件を満たしたら
            if ((_diffTokuten / 2 <= childTokutenList[i][j]) &&
                (childTokutenList[i][j] < _minDirectDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minDirectDiff = childTokutenList[i][j];
              textDirect = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  childTokutenList[i][j].toString() +
                  "点";
            } else if (12800 < _diffTokuten) {
              if (_diffTokuten <= 16000) {
                textDirect = "満貫";
              } else if (_diffTokuten <= 24000) {
                textDirect = "跳満";
              } else if (_diffTokuten <= 32000) {
                textDirect = "倍満";
              } else if (_diffTokuten <= 48000) {
                textDirect = "三倍満";
              } else if (_diffTokuten <= 64000) {
                textDirect = "役満";
              } else {
                textDirect = "無し";
              }
            }
            //ツモ条件を満たしたら
            if ((_diffTokuten <= childTsumoList[i][j]) &&
                (childTsumoList[i][j] < _minTsumoDiff)) {
              //今までより安い手で逆転できる時
              //逆転条件の点数を更新する
              _minTsumoDiff = childTsumoList[i][j];
              textTsumo = ((i + 3) * 10).toString() +
                  "符" +
                  (j + 1).toString() +
                  "翻:" +
                  childTokutenList[i][j].toString() +
                  "点";
            } else if (8000 < _diffTokuten) {
              if (_diffTokuten <= 1000) {
                textTsumo = "満貫";
              } else if (_diffTokuten <= 15000) {
                textTsumo = "跳満";
              } else if (_diffTokuten <= 20000) {
                textTsumo = "倍満";
              } else if (_diffTokuten <= 30000) {
                textTsumo = "三倍満";
              } else if (_diffTokuten <= 40000) {
                textTsumo = "役満";
              } else {
                textTsumo = "無し";
              }
            }
          }
        }
      }
    });
  }

  //得点がフォームに入力されているか確認
  void checkTokutenForm() {
    if (myTokuten.text == "" || yourTokuten.text == "") {
      _showDialog();
    } else {
      calcTokuten();
    }
  }

  //ダイアログ表示
  Future<void> _showDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('入力エラー'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text("点棒を入力してください!")],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('はい'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('得点差計算ツール'),
      ),
      body: Column(children: <Widget>[
        Container(
            padding: EdgeInsets.all(16),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "自分の点棒", hintText: "点棒を入力して下さい"),
                controller: myTokuten,
              ),
              CheckboxListTile(
                value: mySwitchValue,
                title: Text(
                  "親",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool value) {
                  setState(() {
                    mySwitchValue = value;
                    //親にチェックを入れた時
                    if (value) {
                      //相手の親チェックを外す
                      yourSwitchValue = !value;
                    }
                  });
                },
              ),
            ])),
        Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "相手の点棒", hintText: "点棒を入力して下さい"),
                  controller: yourTokuten,
                ),
                CheckboxListTile(
                  value: yourSwitchValue,
                  title: Text(
                    "親",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool value) {
                    setState(() {
                      yourSwitchValue = value;
                      //相手の親チェックをした時
                      if (value) {
                        //自分の親チェックを外す
                        mySwitchValue = !value;
                      }
                    });
                  },
                ),
              ],
            )),
        Container(
            padding: EdgeInsets.all(16),
            child: Column(children: <Widget>[
              RaisedButton(
                elevation: 16,
                child: const Text('計算'),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: checkTokutenForm,
                highlightElevation: 16,
                highlightColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "直撃:" + textDirect,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "ツモ:" + textTsumo,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "出アガリ:" + textOther,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ])),
      ]),
    );
  }
}
