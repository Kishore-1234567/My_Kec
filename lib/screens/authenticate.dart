import 'package:flutter/material.dart';
import 'package:my_kec/widgets/loginandsignup.dart';

class AuthenticationScreen extends StatefulWidget {
  VoidCallback func;
  AuthenticationScreen({Key? key, required this.func}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isLogin = true;
  void changeMode(bool v) {
    setState(() {
      isLogin = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Stack(
            children: [
              LoginandSignup(func: widget.func, isLogin: changeMode),
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
                    margin: isLogin
                        ? const EdgeInsets.only(top: 150)
                        : const EdgeInsets.only(top: 70),
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
