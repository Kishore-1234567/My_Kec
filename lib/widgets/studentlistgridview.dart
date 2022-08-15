import 'package:flutter/material.dart';
import 'package:my_kec/screens/studentinfoscreen.dart';

class StudentListGridview extends StatelessWidget {
  const StudentListGridview({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
          ),
          itemCount: data['students'].length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StudentInfoScreen(
                        rollNumber: data['students'][index])));
              }),
              child: Card(
                elevation: 5,
                child: Center(
                  child: Text(
                    data['students'][index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
