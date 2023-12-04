import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:finalonepiconeword/winpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  List someImages = [];
  String imagePath= 'images/LION.jpg';
  List answerList=[];
  List topList=[];
  List bottomList=[];
  late int a;
  late String spelling;
  Map map = {};
  List checkList = [];
  final player = AudioPlayer();
  final flutterTts = FlutterTts();
  int coin  = 100;
  bool isSpeaking = false;
  Color textColor = Colors.yellow;

  @override
  void initState() {
    _initImages();
    initializeTts();
  }

  Future<void> speak() async {
    if(spelling != ''){
     await flutterTts.speak(spelling);
    }
  }

  stop() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
         color: Colors.black54,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 InkWell(
                   onTap: () {
                     showDialog(
                       barrierDismissible: false,
                       context: context, builder: (context) {
                       return AlertDialog(
                         elevation: 0,
                         title: Text('Spend 150 Coins ?'),
                         actions: [
                           TextButton(onPressed: () {
                             Navigator.pop(context);
                           }, child: Text('cancle')),

                           TextButton(onPressed: () {

                             if(coin<150){
                               Fluttertoast.showToast(msg: 'you have not enough coins !');
                             }
                             else{
                               Navigator.pop(context);
                               setState(() {
                                 coin = coin - 150;
                               });
                               isSpeaking ? stop() : speak();
                             }

                           }, child: Text('ok')),
                         ],
                       );
                     },);

                   },
                   child: Container(
                     margin: EdgeInsets.only(left: 20,top: 15),
                     height: 40,
                     width: 40,
                     decoration: BoxDecoration(
                       color: Colors.deepOrange,
                       shape: BoxShape.circle
                     ),
                     child: Icon(isSpeaking ? CupertinoIcons.speaker_2_fill : CupertinoIcons.speaker_fill,color: Colors.white,),
                   ),
                 ),

                  Container(height: 40,
                  margin: EdgeInsets.only(top: 10,right: 10),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(21),
                  ),
                    child: Row(
                      children: [
                        Image.asset('images/coin.png'),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text('$coin',style: TextStyle(color: Colors.white,fontSize: 18),),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              Container(
                height: 380,
                width: 400,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.white,blurRadius: 10),
                  ],
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(color: Colors.white,width: 1),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset('$imagePath',fit: BoxFit.fill,)),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: topList.map((e) {
                  return InkWell(
                    onTap: (){
                      player.play(AssetSource('tap.mp3')).then((value) {
                        for(int i=0; i<answerList.length; i++){
                          if(e == topList[i] && e != ''){
                            setState(() {
                              bottomList[map[i]] = e;
                              topList[i] = '';
                              e='';
                            });
                            break;
                          }
                        }
                      });


                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.only(right: 5,left: 5,top: 30,bottom: 20),
                      height: 45,width: 45,
                      child: Center(child: Text(e,style: TextStyle(fontSize: 30,color: textColor ,fontWeight: FontWeight.bold),)),
                    ),
                  );
                }).toList(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 130,
                    width: 320,
                    margin: EdgeInsets.only(top: 45),
                    child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5), itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          player.play(AssetSource('tap2.mp3')).then((value) {
                            for(int i=0; i<topList.length; i++){
                              if(topList[i] == ''){
                                setState(() {
                                  topList[i] = bottomList[index];
                                  bottomList[index] = '';
                                  map[i] = index;
                                });
                                break;
                              }
                            }
                            check();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5,left: 5,bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Text('${bottomList[index]}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
                        ),
                      );
                    },
                    itemCount: bottomList.length,
                    ),
                  ),

                  InkWell(
                    onTap: () {

                      if(coin<60){
                        Fluttertoast.showToast(msg: 'you have not enough coins');
                      }
                      else{
                        setState(() {
                          bottomList.removeWhere((element) => !answerList.contains(element));
                          coin = coin - 60;
                        });
                      }
                    },
                    child: Container(
                      height: 115,
                      width: 70,
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.search,color: Colors.white,size: 45,),

                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            decoration: BoxDecoration(
                              color: Colors.lime,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.white,blurRadius: 2)],
                            ),
                            child: Row(
                              children: [
                                Container(height: 30,width: 30,child: Image.asset('images/coin.png')),
                                Text('60'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  Future _initImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('.jpg'))
        .toList();

    setState(() {
      someImages = imagePaths;
    });

    a = Random().nextInt(someImages.length);
    imagePath = someImages[a];
    spelling = imagePath.split('/')[1].split('\.')[0];
    answerList = spelling.split('');
    topList = List.filled(answerList.length, '');

    String abcd = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    abcdList = abcd.split('');
    abcdList.shuffle();
    bottomList = abcdList.getRange(0, 10 - answerList.length).toList();
    bottomList.addAll(answerList);
    bottomList.shuffle();
    print(bottomList);
  }
  void check() {

    for(int i=0; i<topList.length; i++){
      if(topList.toString() == answerList.toString()){
        setState(() {
          coin = coin + 50;
        });
        print('you are win');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Win();
        },));
        _initImages();
        break;
      }
    }

    if(!topList.contains('') && topList.toString() != answerList.toString()){

      player.play(AssetSource('wrong.mp3')).then((value) {
        player.setVolume(100);
        Fluttertoast.showToast(msg: 'wrong !');
        setState(() {
          textColor = Colors.red;
        });
      });
    }
    else{
      setState(() {
        textColor = Colors.yellow;
      });
    }
  }
  void initializeTts() {

    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }
  List abcdList = [];
}
