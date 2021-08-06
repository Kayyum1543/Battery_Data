import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Battery",

      home:HomePage() ,


    );
  }

}


class HomePage extends StatefulWidget{
  @override
  _HomePageState createState()=>_HomePageState();
}

class _HomePageState  extends State<HomePage>{
  Battery b = Battery();
  int showBatteryLevels = 0;
  BatteryState state=BatteryState.discharging;
  bool broadcastBattery = false;

  Color COLOR_RED= Colors.red;
  Color COLOR_GREEN = Colors.green.shade700;
  Color COLOR_GREY= Colors.grey;
  final databaseReference = FirebaseDatabase.instance.reference().child("Kayyum");

  @override
  void initState(){
    super.initState();
    _broadcastBatteryLevels();
    b.onBatteryStateChanged.listen((event) {
      setState(() {
        state = event;
      });


    });



  }
  _broadcastBatteryLevels() async{
    broadcastBattery = true;
    while(broadcastBattery){
      var bit = await b.batteryLevel;
      setState(() {
        showBatteryLevels = bit;
        String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
       databaseReference.child(now).set({
         "Battery"  : "$bit %",
         "Time"  : now,
         "Status" : state.toString(),



       });


      });
      await Future.delayed(Duration(seconds : 5));
    }


  }
  @override
  void dispose(){

    super.dispose();
    setState(() {
      broadcastBattery = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child:Column(
              children: [
                Container(

                  margin: EdgeInsets.only(top: 50),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 7,
                            spreadRadius: -5,
                            offset: Offset(4,4),
                            color: COLOR_GREY


                        ),

                      ]



                  ),
                  child: SfRadialGauge(
                    axes:[
                      RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          startAngle: 270,
                          endAngle: 270,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                              thickness: 1,
                              color: showBatteryLevels  <= 10 ? COLOR_RED : COLOR_GREEN,
                              thicknessUnit: GaugeSizeUnit.factor
                          ),

                          pointers: <GaugePointer>[
                            RangePointer(
                              value: double.parse(showBatteryLevels.toString()),
                              width: 0.3,
                              color: Colors.white,
                              pointerOffset: 0.1,
                              cornerStyle: showBatteryLevels == 100  ? CornerStyle.bothFlat : CornerStyle.endCurve,
                              sizeUnit: GaugeSizeUnit.factor,
                            ),

                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                positionFactor:0.5,
                                angle: 90,
                                widget: Text(
                                  showBatteryLevels == null ? "0": showBatteryLevels.toString() + " %",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ))
                          ]),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          batteryContainer(70,
                              Icons.power, 40,
                              showBatteryLevels <=10 ? COLOR_RED : COLOR_GREEN,
                              state == BatteryState.charging ? true : false
                          ),
                          batteryContainer(
                              70,
                              Icons.power_off, 40,
                              showBatteryLevels <=10 ? COLOR_RED : COLOR_GREEN,
                              state == BatteryState.discharging ? true : false
                          ),
                          batteryContainer(70,
                              Icons.battery_charging_full, 40,
                              showBatteryLevels <=10 ? COLOR_RED : COLOR_GREEN,
                              state == BatteryState.full ? true : false
                          ),

                        ],),
                    )
                )


              ],
            ),
          ),

        ));
  }

  batteryContainer(double size, IconData icon, double iconSize, Color iconColor, bool hasGLow) {
    return Container(
      width: size,
      height: size,
      child: Icon(
        icon,
        size: iconSize,
        color : iconColor,


      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            hasGLow ? BoxShadow(blurRadius: 10 , spreadRadius: 2, offset: Offset(0, 0),color: iconColor) : BoxShadow(
                blurRadius: 7,
                spreadRadius: -5,
                offset: Offset(2, 2),
                color: COLOR_GREY
            )
          ]
      ),
    );
  }
}