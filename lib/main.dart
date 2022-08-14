import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_kec/screens/authenticate.dart';
import 'package:my_kec/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const Mysplash()));
}

Future<bool?> getuser() async {
  final pref = await SharedPreferences.getInstance();
  bool? islogin = pref.getBool('islogin');
  return islogin;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void changeAuthState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getuser(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data as bool) {
          return TabScreen(
            func: changeAuthState,
          );
        } else if (snapshot.data == null || !(snapshot.data as bool)) {
          return AuthenticationScreen(
            func: changeAuthState,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class Mysplash extends StatefulWidget {
  const Mysplash({Key? key}) : super(key: key);

  @override
  State<Mysplash> createState() => _MysplashState();
}

class _MysplashState extends State<Mysplash> with TickerProviderStateMixin {
  final String wrd = "Transform Yourself";

  late AnimationController _anc;
  late AnimationController _Wanc;
  late Animation<double> _ani;
  late Animation<double> _Wani;

  @override
  void initState() {
    _anc =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _ani = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_anc);
    _anc.forward();

    _Wanc =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _Wani = Tween(
      begin: 0.0,
      end: 0.95,
    ).animate(_Wanc);

    _Wanc.forward();
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const MyApp())));
  }

  @override
  void dispose() {
    _Wanc.dispose();
    _anc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: "Logo",
                child: FadeTransition(
                  opacity: _ani,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(4, 4),
                              blurRadius: 15),
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 15)
                        ]),
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/keclogo.gif',
                            fit: BoxFit.fill,
                            height: 50,
                            width: 50,
                          ),
                        )),
                  ),
                )),
            Hero(
                tag: "TY",
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 80),
                  width: 200,
                  height: 30,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: wrd.length,
                      itemBuilder: (context, index) {
                        final String a = wrd[index];
                        return FadeTransition(
                          opacity: _Wani,
                          child: Text(a),
                        );
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
