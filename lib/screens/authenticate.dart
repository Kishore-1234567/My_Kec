import 'package:flutter/material.dart';
import 'package:my_kec/widgets/loginandsignup.dart';

class AuthenticationScreen extends StatelessWidget {
  VoidCallback func;
  AuthenticationScreen({Key? key,required this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Stack(
            children: [
              LoginandSignup(func:func),
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
                    margin: const EdgeInsets.only(top: 100),
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
