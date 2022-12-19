import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_smart_home/view/auth/signIn.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:my_smart_home/view/LivingRoom/livingRoom.dart';
import 'package:my_smart_home/view/Kitchen/kitchen.dart';
import 'package:my_smart_home/view/GuestRoom/guestRoom.dart';
import 'package:my_smart_home/view/BedRoom/bedRoom.dart';
import 'package:my_smart_home/view/temperature/temperature.dart';
import 'dart:async';
import 'package:intl/intl.dart';

Future<void> main() async {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePage createState() => _HomePage();
}

String? userName = "";
String? userEmail = "";

class _HomePage extends State<HomePage> {
  double temperature = 0.0;
  int humidity = 0;
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
        FirebaseFirestore.instance
            .collection('consumption')
            .doc(currentUser.uid)
            .collection("temperature")
            .doc()
            .set({'temperature': temperature}).then((res) {
          log('set temperature');
        }).catchError((err) {
          log(err.toString());
        });
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
          humidity = value;
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
        .then((value) => {
              setState(() {
                userName = value['username']; // clear any existing errors
              }),
              setState(() {
                userEmail = value['email']; // clear any existing errors
              })
            });
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'E-Home',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Profile'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    currentScreen.width * 0.2),
                                child: const AdvancedAvatar(
                                    statusSize: 12,
                                    statusColor: Colors.green,
                                    margin: EdgeInsets.only(right: 12),
                                    image:
                                        AssetImage('assets/images/avatar.png'),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            offset: Offset(10, 15),
                                            color: Color(0x22000000),
                                            blurRadius: 20.0)
                                      ],
                                    ))),
                            SizedBox(
                              height: currentScreen.height * 0.02,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Text(
                                "Username\n${userName?.toString()}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: currentScreen.height * 0.02,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Text(
                                "Email \n${userEmail?.toString()}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const AdvancedAvatar(
                  statusSize: 12,
                  statusColor: Colors.green,
                  size: 40,
                  margin: EdgeInsets.only(right: 16),
                  image: AssetImage('assets/images/avatar.png'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 16.0,
                      ),
                    ],
                  )),
            ),
          ],
        ),
        body: SafeArea(
            child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                shrinkWrap: true,
                children: [
              Card(
                elevation: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Hello ${userName?.toString()}  !',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      textColor: Colors.white,
                      subtitle: const Text(
                        'Good morning, welcome back',
                        style: TextStyle(color: Colors.black38),
                      ),
                    ),
                    Text(
                      DateFormat.yMEd().add_jms().format(DateTime.now()),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black38),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                child: Card(
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Temperature()));
                },
              ),
              const SizedBox(height: 8),
              InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: currentScreen.height * 0.180,
                    decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images/livingRoom.jpg"),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                            title: Text('Living Room',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            subtitle: Text('6 Devices',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LivingRoom()));
                },
              ),
              const SizedBox(height: 8),
              InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: currentScreen.height * 0.180,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bedroom.jpg"),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                            title: Text('Bed Room',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            subtitle: Text('5 Devices',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BedRoom()));
                },
              ),
              const SizedBox(height: 8),
              InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: currentScreen.height * 0.180,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/kitchen.jpg"),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                            title: Text('Kitchen',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            subtitle: Text('4 Devices',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Kitchen()));
                },
              ),
              InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: currentScreen.height * 0.180,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/guestRoom.webp"),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        ListTile(
                            title: Text('Guest Room',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            subtitle: Text('5 Devices',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const GuestRoom()));
                },
              ),
            ])),
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7, //<-- SEE HERE
            child: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.blue),
                    accountName: Text(
                      "${userName?.toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    accountEmail: Text(
                      "${userEmail?.toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.black54,
                    ),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SignIn()));
                    },
                  ),
                  const AboutListTile(
                    // <-- SEE HERE
                    icon: Icon(
                      Icons.info,
                      color: Colors.black54,
                    ),
                    applicationIcon: Icon(
                      Icons.home_filled,
                    ),
                    applicationName: 'E-home',
                    applicationVersion: '1.0.25',
                    applicationLegalese: '© 2022 DevBoris',
                    aboutBoxChildren: [
                      ///Content goes here...
                    ],
                    child: Text('About E-home'),
                  ),
                ],
              ),
            )),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications), onPressed: () {}),
              const Spacer(),
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add), onPressed: () {
           showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add a new Room'),
                content: SingleChildScrollView(
                child: ListBody(
                children: const <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Room Name"),
                  ),
                  SizedBox(height: 8),
                  Text('Not yet implemented', style: TextStyle(color: Colors.redAccent)),
                ],
                )),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
