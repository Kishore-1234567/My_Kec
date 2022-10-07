import 'package:flutter/material.dart';
import 'package:my_kec/widgets/login.dart';

class AuthenticationScreen extends StatefulWidget {
  VoidCallback func;
  AuthenticationScreen({Key? key, required this.func}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: Stack(
            children: [
              LoginandSignup(func: widget.func),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 150),
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/keclogo.gif',
                            fit: BoxFit.fill,
                            height: 100,
                            width: 100,
                          ),
                        )),
                  )),
            ],
          ),
        ));
  }
}
