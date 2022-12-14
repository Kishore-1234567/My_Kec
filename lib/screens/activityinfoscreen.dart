import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/apis.dart';

// ignore: must_be_immutable
class ActivityInfoScreen extends StatefulWidget {
  String rollNumber;
  ActivityInfoScreen({Key? key, required this.rollNumber}) : super(key: key);

  @override
  State<ActivityInfoScreen> createState() => _ActivityInfoScreenState();
}

class _ActivityInfoScreenState extends State<ActivityInfoScreen> {
  List<String> activityList = [
    '',
    'Paper Presentation',
    'Project Presentation',
    'Techno Managerial Event',
    'Sports & Games',
    'Membership',
    'Leadership/Organizing Event',
    'VAC/Online Courses',
    'Project to Paper/Patent/Copyright',
    'GATE/CAT/Govt Examns',
    'Placement and Internship',
    'Entrepreneurship',
    'Social Activities'
  ];
  Future<List<dynamic>> getSAPDetail() async {
    String batch = "20${widget.rollNumber.substring(0, 2)}";
    final response = await http.post(Uri.https(DOMAIN_NAME, GETSAPDETAIL),
        body: {'rollNumber': widget.rollNumber, 'studentBatch': batch});

    return jsonDecode(response.body);
  }

  showAlert(
      BuildContext context, String theme, String point, String sapid) async {
    final pref = await SharedPreferences.getInstance();
    String studentBatch = pref.getString('studentBatch') as String;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text("Are You Sure Want To $theme ?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () async {
                final response = await http.post(
                    Uri.https("mykecerode.000webhostapp.com",
                        "AppApi/Staff/allocatemark.php"),
                    body: {
                      'point': theme == 'Approve' ? point : '0',
                      'studentBatch': studentBatch,
                      'sapid': sapid,
                      'stateOfProcess': theme == 'Approve' ? '1' : '2'
                    });
                if (response.body.contains('Success')) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Point Allocation successfull')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Something Gone wrong')));
                }
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            ElevatedButton(
              child: const Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rollNumber,
            style: const TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder(
          future: getSAPDetail(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<dynamic>;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    final tc = TextEditingController(
                        text: data[index]['expectedMark']);
                    return Card(
                      elevation: 20,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: Text(
                                activityList[
                                    int.parse(data[index]['sapCategory'])],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            data[index]['sapCategory'] == '1' ||
                                    data[index]['sapCategory'] == '2' ||
                                    data[index]['sapCategory'] == '3'
                                ? SizedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                            'Organizer : ${data[index]['documentTitle']}'),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            'PrizeWon : ${data[index]['prizeWon'].toString() == '0' ? 'Participated' : 'Yes'}'),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  const Text('Expected Mark : '),
                                  SizedBox(
                                    width: 80,
                                    height: 30,
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: tc,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(DateFormat(
                                          'dd-MM-yyyy \n\t\t\t\t\t\t\t\t\t kk:mm')
                                      .format(DateTime.parse(data[index]
                                              ['TimeOfUpload']
                                          .toString()))),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                data[index]['description'],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () {
                                        if (tc.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('Enter Marks')));
                                        } else if (!RegExp(r'^[0-9]+$')
                                            .hasMatch(tc.text)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'It Should contain only numbers')));
                                        } else {
                                          showAlert(context, 'Approve', tc.text,
                                              data[index]['sapId']);
                                        }
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.done,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Accept',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      onPressed: () {
                                        showAlert(context, 'Reject', '',
                                            data[index]['sapId']);
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.close,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Reject',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    width: 110,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(),
                                        onPressed: () {
                                          try {
                                            launchUrl(Uri.parse(data[index]
                                                    ['documentLink']
                                                .toString()));
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Unable to open File')));
                                          }
                                        },
                                        child: const Text(
                                          'View PDF',
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
