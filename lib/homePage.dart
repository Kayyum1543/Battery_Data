import 'package:battery_info/main.dart';
import 'package:flutter/material.dart';

void main() => runApp(ButtonPage());

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removing the debug banner when running on simulators
        debugShowCheckedModeBanner: false,
        title: 'An Aweasome App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                // just an empty SizedBox to add some spacing
                SizedBox(height: 30,),

                Container(
                  // set width equal to height to make a square
                    width: 200,
                    height: 200,
                    child: RaisedButton(
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        // set the value to a very big number like 100, 1000...
                          borderRadius: BorderRadius.circular(100)),
                      child: Text('I am a button'),
                      onPressed: () {
                        HomePage();



                      },
                    ))
              ],
            ),
          ),
        ));
  }
}