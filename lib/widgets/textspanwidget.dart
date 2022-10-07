
import 'package:flutter/material.dart';

class TextSpanWidget extends StatelessWidget {
  const TextSpanWidget({
    Key? key,
    required this.heading,
    required this.description,
  }) : super(key: key);

  final String heading;
  final String description;

  @override
  Widget build(BuildContext context) {
    var brightness=MediaQuery.of(context).platformBrightness;
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              text: heading,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color:brightness==Brightness.dark?Colors.white:Colors.black )),
          TextSpan(
            text: '\n\t\t\t\t$description',
            style: TextStyle(color:brightness==Brightness.dark?Colors.white:Colors.black)
          ),
        ],
      ),
    );
  }
}
