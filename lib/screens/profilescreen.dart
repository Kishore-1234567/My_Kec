import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_kec/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/staffdetails.dart';
import '../widgets/studentlistgridview.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final style = const TextStyle(fontSize: 18);

  Future<Map<String, dynamic>> getStaffDetails() async {
    final pref = await SharedPreferences.getInstance();
    String staffId = pref.getString('staffId') as String;
    final response1 = await http.post(
        Uri.https(
            DOMAIN_NAME, GETSTAFFDATA),
        body: {'staffId': staffId});
    String semester = jsonDecode(response1.body)[0]['currentSemester'];
    return {
      'staffId': pref.getString('staffId') as String,
      'name': pref.getString('name') as String,
      'email': pref.getString('email') as String,
      'department': pref.getString('department') as String,
      'currentYear': (int.parse(semester) / 2).ceil(),
      'studentBatch': pref.getString('studentBatch') as String,
      'semester': semester,
      'section': pref.getString('section') as String,
      'students': pref.getStringList('students') as List
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStaffDetails(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as Map<String, dynamic>;
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                  child: Text(
                    'Your Details',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: StaffDetails(style: style, data: data),
                ),
                const SizedBox(
                  height: 20,
                  child: Text(
                    'Student List',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8),
                  child: StudentListGridview(data: data),
                )),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something gone wrong'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
