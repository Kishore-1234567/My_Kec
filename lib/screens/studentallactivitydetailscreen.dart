import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentAllActivityDetailsScreeen extends StatefulWidget {
  String rollNumber;
  StudentAllActivityDetailsScreeen({Key? key, required this.rollNumber})
      : super(key: key);

  @override
  State<StudentAllActivityDetailsScreeen> createState() =>
      _StudentAllActivityDetailsScreeenState();
}

class _StudentAllActivityDetailsScreeenState
    extends State<StudentAllActivityDetailsScreeen> {
  final controller = TextEditingController();
  String category = 'All';
  List<String> categoryList = [
    'All',
    'Paper',
    'Project',
    'Techno Managerial',
    'Sports & Games',
    'Membership',
    'Leadership/Organizing',
    'VAC/Online Courses',
    'Project to Paper/Patent/Copyright',
    'GATE/CAT/Govt Examns',
    'Placement and Internship',
    'Entrepreneurship',
    'Social Activities'
  ];

  Future<List<dynamic>> getDetailOfSAP() async {
    String studentBatch = "20${widget.rollNumber.substring(0, 2)}";
    final response = await http.post(
        Uri.https("mykecerode.000webhostapp.com",
            "AppApi/Staff/getstudentallsapdetail.php"),
        body: {'rollNumber': widget.rollNumber, 'studentBatch': studentBatch});
    return jsonDecode(response.body);
  }

  void bottomsheet(String id) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Point field should not be empty',
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        return;
                      }
                      showAlert(id);
                    },
                    child: const Text('Update')),
              ],
            ),
          );
        });
  }

  void showAlert(String id) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text("Are You Sure Want To Update Score?"),
          actions: <Widget>[
            ElevatedButton(
                child: const Text("YES"),
                onPressed: () async {
                  // final doc = await FirebaseFirestore.instance
                  //     .collection('staffs')
                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     .get();
                  // final data = doc.data() as Map<String, dynamic>;
                  // await FirebaseFirestore.instance
                  //     .collection('Sap')
                  //     .doc(data['stuyear'])
                  //     .collection(data['department'])
                  //     .doc(data['section'])
                  //     .collection(widget.roll)
                  //     .doc(id)
                  //     .update({'allotedmark': tc.text});
                  // Navigator.pop(context);
                  setState(() {});
                }),
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

  int calTotalScore(list) {
    int totalScore = 0;
    for (var element in list) {
      totalScore += int.parse(element['allocatedMark']);
    }
    return totalScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rollNumber),
      ),
      body: FutureBuilder(
        future: getDetailOfSAP(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as List<dynamic>;
            List<dynamic> list = data;
            if (category == 'Paper') {
              list = data
                  .where((element) => element['sapCategory'] == '1')
                  .toList();
            } else if (category == 'Project') {
              list = data
                  .where((element) => element['sapCategory'] == '2')
                  .toList();
            } else if (category == 'Techno Managerial') {
              list = data
                  .where((element) => element['sapCategory'] == '3')
                  .toList();
            } else if (category == 'Sports & Games') {
              list = data
                  .where((element) => element['sapCategory'] == '4')
                  .toList();
            } else if (category == 'Membership') {
              list = data
                  .where((element) => element['sapCategory'] == '5')
                  .toList();
            } else if (category == 'Leadership/Organizing') {
              list = data
                  .where((element) => element['sapCategory'] == '6')
                  .toList();
            } else if (category == 'VAC/Online Courses') {
              list = data
                  .where((element) => element['sapCategory'] == '7')
                  .toList();
            } else if (category == 'Project to Paper/Patent/Copyright') {
              list = data
                  .where((element) => element['sapCategory'] == '8')
                  .toList();
            } else if (category == 'GATE/CAT/Govt Examns') {
              list = data
                  .where((element) => element['sapCategory'] == '9')
                  .toList();
            } else if (category == 'Placement and Internship') {
              list = data
                  .where((element) => element['sapCategory'] == '10')
                  .toList();
            } else if (category == 'Entrepreneurship') {
              list = data
                  .where((element) => element['sapCategory'] == '11')
                  .toList();
            } else if (category == 'Social Activities') {
              list = data
                  .where((element) => element['sapCategory'] == '12')
                  .toList();
            }
            int totalScore = calTotalScore(list);
            int divisor = 100;
            if (category == 'Techno Managerial' || category == 'Paper') {
              divisor = 75;
            } else if (category == 'Entrepreneurship' ||
                category == 'Social Activities') {
              divisor = 50;
            } else {
              divisor = 100;
            }
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Progress(totalScore: totalScore, divisor: divisor)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const SizedBox(child: Text('Filter  :')),
                    const Spacer(),
                    DropdownButton(
                        value: category,
                        icon: const Icon(Icons.dns),
                        items: categoryList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, softWrap: true),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value.toString();
                          });
                        })
                  ]),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (ctx, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Text(
                                  list[index]['allocatedMark'],
                                  softWrap: true,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(categoryList[
                                  int.parse(list[index]['sapCategory'])]),
                              trailing: SizedBox(
                                width: 120,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          bottomsheet(list[index]['sapId']);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    ElevatedButton(
                                        onPressed: () {
                                          try {
                                            launchUrl(Uri.parse(
                                                list[index]['documentLink']));
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Unable to open File')));
                                          }
                                        },
                                        child: const Text('PDF')),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }))
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to Fetch Records'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({
    Key? key,
    required this.totalScore,
    required this.divisor,
  }) : super(key: key);

  final int totalScore;
  final int divisor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularPercentIndicator(
          radius: 50,
          percent: totalScore > divisor ? 1 : totalScore / divisor,
          center: Text(
            '$totalScore',
            style: const TextStyle(fontSize: 40),
          ),
          animation: true,
          progressColor: Colors.green,
          backgroundColor: const Color.fromARGB(255, 223, 212, 212),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Max Score : $divisor'),
            Text(
                'Needed points : ${(divisor - totalScore) < 0 ? 0 : divisor - totalScore}'),
          ],
        ),
      ],
    );
  }
}
