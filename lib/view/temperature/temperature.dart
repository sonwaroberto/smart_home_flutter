import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

Future<void> main() async {
  runApp(const Temperature());
}

class Temperature extends StatefulWidget {
  const Temperature({super.key});
  @override
  _Temperature createState() => _Temperature();
}

String? userName = "";

int bathHomeStats = 0;
DatabaseReference ref = FirebaseDatabase.instance.ref('smartHome/livingRoom');

class _Temperature extends State<Temperature> {
  double temperature = 0.0, humidity = 0.0, heatIndex = 0.0;
  final List<Feature> features = [
    Feature(
      title: "Temperature",
      color: const Color(0xff1C2436),
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
    Feature(
      title: "Heat Index",
      color: Colors.blueGrey,
      data: [0.5, 0.4, 0.85, 0.4, 0.9],
    ),
    Feature(
      title: "Humidity",
      color: Colors.blue,
      data: [0.6, 0.2, 0, 0.1, 1],
    ),
  ];
  bool isLoading = true;
  final currentUser = FirebaseAuth.instance.currentUser!;
  getTemperature() async {
    FirebaseDatabase.instance
        .ref("smartHome/temperature")
        .onValue
        .listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      data.forEach((key, value) {
        setState(() {
          temperature = value;
        });
        // FirebaseFirestore.instance
        //     .collection('consumption')
        //     .doc(currentUser.uid)
        //     .collection("temperature")
        //     .doc()
        //     .set({'temperature': temperature}).then((res) {
        //   log('set temperature');
        // }).catchError((err) {
        //   log(err.toString());
        // });
      });
    });
    setState(() {
      isLoading = false;
    });
  }
  getHumidity() async {
    FirebaseDatabase.instance.ref("smartHome/humidity").onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      data.forEach((key, value) {
        setState(() {
          humidity = value + .0;
        });
        FirebaseFirestore.instance
            .collection('consumption')
            .doc(currentUser.uid)
            .collection("humidity")
            .doc()
            .set({'humidity': humidity}).then((res) {
          log('set humidity');
        }).catchError((err) {
          log(err.toString());
        });
      });
    });
    setState(() {
      isLoading = false;
    });
  }
  getHeatIndex() async {
    FirebaseDatabase.instance
        .ref("smartHome/heatIndex")
        .onValue
        .listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      data.forEach((key, value) {
        setState(() {
          heatIndex = value;
        });
        FirebaseFirestore.instance
            .collection('consumption')
            .doc(currentUser.uid)
            .collection("heatIndex")
            .doc()
            .set({'heatIndex': humidity}).then((res) {
          log('set heatIndex');
        }).catchError((err) {
          log(err.toString());
        });
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    getTemperature();
    getHumidity();
    getHeatIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    Size currentScreen = MediaQuery.of(context).size;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => setState(() {
              userName = value['username']; // clear any existing errors
            }));
    // FirebaseFirestore.instance
    //     .collection('consumption')
    //     .doc(user.uid)
    //     .collection('temperature')
    //     .doc()
    //     .get()
    //     .then((value) => {
    //       log('${value.id}')});
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '${userName?.toString()} E-Home',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  children: [
                    Card(
                      child: Column(children: [
                        ListTile(
                          horizontalTitleGap: 0,
                          leading: const Icon(
                            Icons.today,
                            color: Colors.blue,
                          ),
                          title: const Center(
                              child: Text(
                            'Today Temperature, Heat Index and Humidity',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          subtitle: Text(
                            DateFormat.yMEd().add_jms().format(DateTime.now()),
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        )
                      ]),
                    ),
                    Center(
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            backgroundImage: const AssetImage(
                                'assets/images/light_frame.png'),
                            minimum: -50,
                            maximum: 50,
                            interval: 10,
                            radiusFactor: 0.5,
                            showAxisLine: false,
                            labelOffset: 5,
                            useRangeColorForAxis: true,
                            axisLabelStyle:
                                GaugeTextStyle(fontWeight: FontWeight.bold),
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: -50,
                                  endValue: -20,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.green,
                                  endWidth: 0.03,
                                  startWidth: 0.03),
                              GaugeRange(
                                  startValue: -20,
                                  endValue: 20,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.yellow,
                                  endWidth: 0.03,
                                  startWidth: 0.03),
                              GaugeRange(
                                  startValue: 20,
                                  endValue: 50,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.red,
                                  endWidth: 0.03,
                                  startWidth: 0.03),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: const Text(
                                    '°F',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  positionFactor: 0.8,
                                  angle: 90)
                            ],
                          ),
                          RadialAxis(
                            ticksPosition: ElementsPosition.outside,
                            labelsPosition: ElementsPosition.outside,
                            minorTicksPerInterval: 5,
                            axisLineStyle: AxisLineStyle(
                              thicknessUnit: GaugeSizeUnit.factor,
                              thickness: 0.1,
                            ),
                            axisLabelStyle: GaugeTextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            radiusFactor: 0.97,
                            majorTickStyle: MajorTickStyle(
                                length: 0.1,
                                thickness: 2,
                                lengthUnit: GaugeSizeUnit.factor),
                            minorTickStyle: MinorTickStyle(
                                length: 0.05,
                                thickness: 1.5,
                                lengthUnit: GaugeSizeUnit.factor),
                            minimum: -60,
                            maximum: 120,
                            interval: 20,
                            startAngle: 115,
                            endAngle: 65,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: -60,
                                  endValue: 120,
                                  startWidth: 0.1,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  endWidth: 0.1,
                                  gradient: const SweepGradient(stops: <double>[
                                    0.2,
                                    0.5,
                                    0.75
                                  ], colors: <Color>[
                                    Colors.green,
                                    Colors.yellow,
                                    Colors.red
                                  ]))
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                  value: temperature,
                                  needleColor: const Color(0xff1C2436),
                                  tailStyle: TailStyle(
                                      length: 0.18,
                                      width: 8,
                                      color: const Color(0xff1C2436),
                                      lengthUnit: GaugeSizeUnit.factor),
                                  needleLength: 0.68,
                                  needleStartWidth: 1,
                                  needleEndWidth: 8,
                                  knobStyle: KnobStyle(
                                      knobRadius: 0.07,
                                      color: Colors.white,
                                      borderWidth: 0.05,
                                      borderColor: Colors.blue),
                                  lengthUnit: GaugeSizeUnit.factor),
                              NeedlePointer(
                                  value: humidity,
                                  needleColor: Colors.blue,
                                  tailStyle: TailStyle(
                                      length: 0.18,
                                      width: 8,
                                      color: Colors.blue,
                                      lengthUnit: GaugeSizeUnit.factor),
                                  needleLength: 0.68,
                                  needleStartWidth: 1,
                                  needleEndWidth: 8,
                                  knobStyle: KnobStyle(
                                      knobRadius: 0.07,
                                      color: Colors.white,
                                      borderWidth: 0.05,
                                      borderColor: Colors.white54),
                                  lengthUnit: GaugeSizeUnit.factor),
                              NeedlePointer(
                                  value: heatIndex,
                                  needleColor: Colors.blueGrey,
                                  tailStyle: TailStyle(
                                      length: 0.18,
                                      width: 8,
                                      color: Colors.blueGrey,
                                      lengthUnit: GaugeSizeUnit.factor),
                                  needleLength: 0.68,
                                  needleStartWidth: 1,
                                  needleEndWidth: 8,
                                  knobStyle: KnobStyle(
                                      knobRadius: 0.07,
                                      color: Colors.white,
                                      borderWidth: 0.05,
                                      borderColor: Colors.white54),
                                  lengthUnit: GaugeSizeUnit.factor)
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: const Text(
                                    '°C',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  positionFactor: 0.8,
                                  angle: 90)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: const Color(0xff1C2436),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              horizontalTitleGap: 2,
                              contentPadding:
                                  const EdgeInsets.only(left: 8, right: 0.0),
                              title: const Text(
                                'Temperature',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              textColor: Colors.white,
                              subtitle: Text(
                                '${temperature.toString()}°C',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                                color: Colors.blueGrey,
                                height: 72,
                                child: ListTile(
                                  horizontalTitleGap: 4,
                                  contentPadding:
                                      const EdgeInsets.only(left: 8, right: 0),
                                  title: const Text(
                                    'Heat Index',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  textColor: Colors.white,
                                  subtitle: Text(
                                    '$heatIndex°C',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                                color: Colors.blue,
                                child: ListTile(
                                  horizontalTitleGap: 4,
                                  contentPadding:
                                      const EdgeInsets.only(left: 8, right: 0),
                                  title: const Text(
                                    'Humidity',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  textColor: Colors.white,
                                  subtitle: Text(
                                    '${humidity.toString()}%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(children: [
                        ListTile(
                          horizontalTitleGap: 0,
                          leading: const Icon(
                            Icons.today,
                            color: Colors.blue,
                          ),
                          title: const Center(
                              child: Text(
                            'This Month Temperature, Heat Index and Humidity',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          subtitle: Text(
                            "${DateTime.now().month} / ${DateTime.now().year}",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        )
                      ]),
                    ),
                    Card(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Container(),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "Statistics",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Color(0xff1C2436)),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: LineGraph(
                                features: features,
                                size: const Size(420, 450),
                                labelX: const ['1', '2', '3', '4', '5'],
                                labelY: const ['0', '20', '40', '50', '70'],
                                showDescription: true,
                                graphColor: Colors.black,
                                verticalFeatureDirection: true,
                                descriptionHeight: 150,
                              ),
                            )
                          ],
                        )),
                  ],
                ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
