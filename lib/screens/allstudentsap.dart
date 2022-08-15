import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_kec/screens/studentallactivitydetailscreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllStudentsSAP extends StatefulWidget {
  const AllStudentsSAP({Key? key}) : super(key: key);

  @override
  State<AllStudentsSAP> createState() => _AllStudentsSAPState();
}

class _AllStudentsSAPState extends State<AllStudentsSAP> {
  String search = '';
  String filterValue = '1';
  String semester = '';
  String key = '1';
  List<DropdownMenuItem<String>> sort = const [
    DropdownMenuItem(value: "1", child: Text("RollNumber")),
    DropdownMenuItem(value: "2", child: Text("RollNumber reverse")),
    DropdownMenuItem(value: "3", child: Text("Highest point firts")),
    DropdownMenuItem(value: "4", child: Text("Least point firts")),
  ];

  Future<List<dynamic>> getstaffData() async {
    final pref = await SharedPreferences.getInstance();
    String staffId = pref.getString('staffId') as String;
    final response1 = await http.post(
        Uri.https(
            "mykecerode.000webhostapp.com", "AppApi/Staff/getstaffdata.php"),
        body: {'staffId': staffId});
    semester = jsonDecode(response1.body)[0]['currentSemester'];
    String studentBatch = pref.getString('studentBatch') as String;
    List<String> students = pref.getStringList('students') as List<String>;
    String studentList = students.join(',');
    final response = await http.post(
        Uri.https("mykecerode.000webhostapp.com",
            "AppApi/Staff/getallstudentpoints.php"),
        body: {
          'studentBatch': studentBatch,
          'semester': semester,
          'studentList': studentList
        });
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.85,
            child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                    hintText: 'Search'),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                }),
          )
        ],
      ),
      body: FutureBuilder(
          future: getstaffData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data as List<dynamic>;
              if (filterValue == '2') {
                data = data.reversed.toList();
              } else if (filterValue == '3') {
                data.sort(((a, b) => a['SUM(allocatedMark)']
                    .toString()
                    .compareTo(b['SUM(allocatedMark)'].toString())));
                data = data.reversed.toList();
              } else if (filterValue == '4') {
                data.sort(((a, b) => a['SUM(allocatedMark)']
                    .toString()
                    .compareTo(b['SUM(allocatedMark)'].toString())));
              }
              return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Sort By  :  ',
                              style: TextStyle(fontSize: 16),
                            ),
                            DropdownButton(
                                value: filterValue,
                                items: sort,
                                onChanged: (value) {
                                  setState(() {
                                    filterValue = value.toString();
                                  });
                                })
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (ctx, index) {
                              int totalScore =
                                  int.parse(data[index]['SUM(allocatedMark)']);
                              return InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              StudentAllActivityDetailsScreeen(
                                                rollNumber: data[index]
                                                    ['studentRollNumber'],
                                                semester: semester,
                                                pageKey: key,
                                              ))),
                                  child: data[index]['studentRollNumber']
                                          .toString()
                                          .toLowerCase()
                                          .contains(search.toLowerCase())
                                      ? Card(
                                          elevation: 10,
                                          child: ListTile(
                                            trailing: CircularPercentIndicator(
                                              radius: 20,
                                              percent: totalScore > 100
                                                  ? 1
                                                  : totalScore / 100,
                                              center: Text('$totalScore'),
                                              progressColor: Colors.green,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 223, 212, 212),
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                            ),
                                            title: Text(data[index]
                                                ['studentRollNumber']),
                                          ),
                                        )
                                      : Container());
                            }),
                      ),
                    ],
                  ));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}



// return InkWell(
  // // onTap: () => Navigator.push(
  // //     context,
  // //     MaterialPageRoute(
  // //         builder: (ctx) =>
  // //             StudentActivityAllDetailsScreeen(
  // //                 roll: stulist[index]))),
  // child: stulist[index]
  //         .toString()
  //         .contains(search)
  //     ? Card(
  //         elevation: 10,
  //         child: ListTile(
  //           trailing: CircularPercentIndicator(
  //             radius: 20,
  //             percent: totalScore > 100
  //                 ? 1
  //                 : totalScore / 100,
  //             center: Text('$totalScore'),
  //             progressColor: Colors.green,
  //             backgroundColor:
  //                 const Color.fromARGB(
  //                     255, 223, 212, 212),
  //             circularStrokeCap:
  //                 CircularStrokeCap.round,
  //           ),
  //           title: Text(stulist[index]),
  //         ),
  //       )
  //     : Container());
