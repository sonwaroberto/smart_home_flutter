import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';

Future<void> main() async {
  runApp(const BedRoom());
}

class BedRoom extends StatefulWidget {
  const BedRoom({super.key});
  @override
  _BedRoom createState() => _BedRoom();
}

String? userName = "";
bool smartLight = false,
    smartAc = false,
    smartTv = false,
    smartDoor = false,
    smartMusic = false;
int bathHomeStats = 0;
DatabaseReference ref = FirebaseDatabase.instance.ref('smartHome/bedRoom');

class _BedRoom extends State<BedRoom> {
  double temperature = 0.0, humidity = 0.0;
  bool ledStatus = false;
  bool isLoading = true;
  final currentUser = FirebaseAuth.instance.currentUser!;
  getLEDStatus() async {
    FirebaseDatabase.instance
        .ref("smartHome/bedRoom")
        .onValue
        .listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      data.forEach((key, value) {
        setState(() {
          ledStatus = value;
        });
      });
    });

    setState(() {
      isLoading = false;
    });
  }
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
  @override
  void initState() {
    isLoading = true;
    getLEDStatus();
    getTemperature();
    getHumidity();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${userName?.toLowerCase()} Bed Room',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView(
            shrinkWrap: true,
            padding:
            const EdgeInsets.symmetric(horizontal: 18),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Bed Room',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.bed,
                    color: Colors.blue,
                    size: 48,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xff1C2436),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        horizontalTitleGap: 2,
                        contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 0.0),
                        leading: const Icon(Icons.thermostat,
                            size: 48, color: Colors.white),
                        title: const Text(
                          'Temperature',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        subtitle: Text(
                          '${temperature.toString()}°C',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        horizontalTitleGap: 4,
                        contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 0.0),
                        leading: const Icon(Icons.ac_unit,
                            size: 48, color: Colors.white),
                        title: const Text(
                          'Humidity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        subtitle: Text(
                          '${humidity.toString()}°C',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  //ac
                  Card(
                    margin:
                    EdgeInsets.only(left: currentScreen.width * 0.04),
                    child: ClipRRect(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: currentScreen.width / 2 - (40),
                        height: 130,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            color: Colors.white54),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Smart Ac",
                                    style: TextStyle(
                                        fontSize:
                                        currentScreen.width * 0.045,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: currentScreen.width * 0.04,
                                  ),
                                  Text(smartAc ? "On" : "Off",
                                      style: TextStyle(
                                          fontSize:
                                          currentScreen.width * 0.05,
                                          fontWeight: FontWeight.w200)),
                                  Switch(
                                      value: smartAc,
                                      activeColor: Colors.cyan,
                                      onChanged: (bool value) =>
                                      smartAc = value),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 15,
                                right: 5,
                                child: Icon(
                                  Icons.ac_unit,
                                  size: 60,
                                  color: smartAc
                                      ? Colors.blue
                                      : Colors.black38,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  //bob
                  Card(
                    margin: EdgeInsets.only(
                        right: currentScreen.width * 0.04),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: currentScreen.width / 2 - (40),
                        height: 130,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            color: Colors.white54),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Smart Bulb",
                                    style: TextStyle(
                                        fontSize:
                                        currentScreen.width * 0.045,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: currentScreen.width * 0.04,
                                  ),
                                  Text(ledStatus ? "On" : "Off",
                                      style: TextStyle(
                                          fontSize:
                                          currentScreen.width * 0.05,
                                          fontWeight: FontWeight.w200)),
                                  Switch(
                                      value: ledStatus,
                                      activeColor: Colors.cyan,
                                      onChanged: (bool value) =>
                                          smartLight(value)),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 15,
                                right: 5,
                                child: Container(
                                  child: Icon(
                                    Icons.lightbulb,
                                    size: 60,
                                    color: ledStatus
                                        ? Colors.yellow
                                        : Colors.black38,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  //door
                  Card(
                    margin:
                    EdgeInsets.only(left: currentScreen.width * 0.04),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: currentScreen.width / 2 - (40),
                        height: 130,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            color: Colors.white54),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Smart Door",
                                    style: TextStyle(
                                        fontSize:
                                        currentScreen.width * 0.045,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: currentScreen.width * 0.04,
                                  ),
                                  Text(smartDoor ? "On" : "Off",
                                      style: TextStyle(
                                          fontSize:
                                          currentScreen.width * 0.05,
                                          fontWeight: FontWeight.w200)),
                                  Switch(
                                      value: smartDoor,
                                      activeColor: Colors.cyan,
                                      onChanged: (bool value) =>
                                      smartDoor = value),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 15,
                                right: 5,
                                child: smartDoor
                                    ? const Icon(
                                    Icons.door_back_door_outlined,
                                    size: 60,
                                    color: Colors.black)
                                    : const Icon(
                                  Icons.door_back_door,
                                  size: 60,
                                  color: Colors.black38,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  //tv
                  Card(
                    margin: EdgeInsets.only(
                        right: currentScreen.width * 0.04),
                    child: ClipRRect(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: currentScreen.width / 2 - (40),
                        height: 130,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            color: Colors.white54),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Smart Tv",
                                    style: TextStyle(
                                        fontSize:
                                        currentScreen.width * 0.045,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: currentScreen.width * 0.04,
                                  ),
                                  Text(smartTv ? "On" : "Off",
                                      style: TextStyle(
                                          fontSize:
                                          currentScreen.width * 0.05,
                                          fontWeight: FontWeight.w200)),
                                  Switch(
                                      value: smartTv,
                                      activeColor: Colors.cyan,
                                      onChanged: (bool value) =>
                                      smartTv = value),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 15,
                                right: 5,
                                child: smartTv
                                    ? const Icon(Icons.tv,
                                    size: 60, color: Colors.yellow)
                                    : const Icon(
                                  Icons.tv_off,
                                  size: 60,
                                  color: Colors.black38,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  //ac
                  Card(
                    margin:
                    EdgeInsets.only(left: currentScreen.width * 0.04),
                    child: ClipRRect(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: currentScreen.width / 2 - (40),
                        height: 130,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            color: Colors.white54),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Smart Music",
                                    style: TextStyle(
                                        fontSize:
                                        currentScreen.width * 0.045,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: currentScreen.width * 0.04,
                                  ),
                                  Text(smartMusic ? "On" : "Off",
                                      style: TextStyle(
                                          fontSize:
                                          currentScreen.width * 0.05,
                                          fontWeight: FontWeight.w200)),
                                  Switch(
                                      value: smartMusic,
                                      activeColor: Colors.cyan,
                                      onChanged: (bool value) =>
                                      smartMusic = value),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 15,
                                right: 5,
                                child: smartMusic
                                    ? const Icon(Icons.music_note,
                                    size: 60, color: Colors.blue)
                                    : const Icon(
                                  Icons.music_off,
                                  size: 60,
                                  color: Colors.black38,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Future<void> smartLight(value) async {
    await ref.set({"bob": !ledStatus}).then((value) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
            const Text("Bed Room", style: TextStyle(color: Colors.blue)),
            content: Text(
              ledStatus ? 'On led successfully' : 'Off led successfully',
              style: const TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }));
  }
}
