import 'package:finalonepiconeword/main.dart';
import 'package:flutter/material.dart';

class Win extends StatefulWidget {
  const Win({super.key});

  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(color: Colors.black38,
      height: double.infinity,
        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
                height: 200,
                width: 200,
                child: Image.asset('images/trophy.png',fit: BoxFit.fill,filterQuality: FilterQuality.high,)),


            SizedBox(height: 50,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/coin.png',height: 60,width: 60,),
                Text('+ 50',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 25,color: Colors.white),)
              ],
            ),

            SizedBox(height: 50,),

            OutlinedButton(onPressed: () {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              },));

            }, child: Text('Next',style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),

    );
  }
}
