import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_kec/api/apis.dart';
import 'package:my_kec/screens/studentallactivitydetailscreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class StudentInfoScreen extends StatelessWidget {
  String rollNumber;
  StudentInfoScreen({Key? key, required this.rollNumber}) : super(key: key);

  Future<Map<String, List>> getStudenData() async {
    final response1 = await http.post(Uri.https(DOMAIN_NAME, GETSTUDENTDATA),
        body: {'rollNumber': rollNumber});
    final response =
        await http.post(Uri.https(DOMAIN_NAME, GETALLSEMSAPDATA), body: {
      'rollNumber': rollNumber,
      'studentBatch': jsonDecode(response1.body)[0]['studentBatch']
    });
    return {
      'studentDetail': jsonDecode(response1.body),
      'sapDetail': jsonDecode(response.body),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(rollNumber, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
        body: FutureBuilder(
          future: getStudenData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as Map<String, dynamic>;
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Text(
                      data['studentDetail'][0]['studentName'],
                      style: const TextStyle(
                          fontSize: 20, overflow: TextOverflow.clip),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ListView.builder(
                        itemCount: data['sapDetail'].length,
                        itemBuilder: (ctx, index) {
                          int totalScore = int.parse(
                              data['sapDetail'][index]['SUM(allocatedMark)']);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          StudentAllActivityDetailsScreeen(
                                            rollNumber: rollNumber,
                                            semester: data['sapDetail'][index]
                                                ['semester'],
                                            pageKey: '0',
                                          )));
                            },
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                trailing: CircularPercentIndicator(
                                  radius: 25,
                                  percent:
                                      totalScore > 100 ? 1 : totalScore / 100,
                                  center: Text('$totalScore'),
                                  progressColor: Colors.green,
                                  backgroundColor:
                                      const Color.fromARGB(255, 223, 212, 212),
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                                title: Text(
                                    'Semester  :  ${data['sapDetail'][index]['semester']}'),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Somthing gone wrong'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
