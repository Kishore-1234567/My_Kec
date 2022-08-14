import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_kec/screens/activityinfoscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SapScreen extends StatefulWidget {
  SapScreen({Key? key}) : super(key: key);

  @override
  State<SapScreen> createState() => _SapScreenState();
}

class _SapScreenState extends State<SapScreen> {
  String search = '';

  Future<List<dynamic>> getstaffData() async {
    final pref = await SharedPreferences.getInstance();
    String studentYear = pref.getString('studentBatch') as String;
    String semester = pref.getString('semester') as String;
    List<String> students = pref.getStringList('students') as List<String>;
    String studentList = students.join(',');
    final response = await http.post(
        Uri.https(
            "mykecerode.000webhostapp.com", "AppApi/Staff/getwaitingsap.php"),
        body: {
          'studentBatch': studentYear,
          'semester': semester,
          'studentList': studentList
        });
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.98,
          child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search'),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              }),
        ),
        Expanded(
          child: FutureBuilder(
              future: getstaffData(),
              builder: (context, ss) {
                if (ss.hasError) {
                  return const Center(
                    child: Text('Something Went Wrong'),
                  );
                }
                if (ss.hasData) {
                  final list = ss.data as List<dynamic>;
                  Map<String, int> data = {};
                  for (var i in list) {
                    if (data.containsKey(i['studentRollNumber'])) {
                      data[i['studentRollNumber']] =
                          (data[i['studentRollNumber']])! + 1;
                    } else {
                      data[i['studentRollNumber']] = 1;
                    }
                  }
                  List<String> rollNumberList = data.keys.toList();
                  List<int> countList = data.values.toList();
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                        itemCount: rollNumberList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ActivityInfoScreen(
                                                rollNumber:
                                                    rollNumberList[index]))));
                              },
                              child: (rollNumberList[index]
                                      .toString()
                                      .toLowerCase()
                                      .contains(search.toLowerCase()))
                                  ? Card(
                                      elevation: 5,
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Text(
                                                  countList[index].toString()),
                                            ),
                                            title: Text(rollNumberList[index]),
                                          )),
                                    )
                                  : Container(
                                      alignment: Alignment.topCenter,
                                      child: const Text(
                                          'No Matching Results Found'),
                                    ));
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ],
    );
  }
}
