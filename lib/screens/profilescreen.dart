import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final style = const TextStyle(fontSize: 18);
  Future<Map<String, dynamic>> getStaffDetails() async {
    final pref = await SharedPreferences.getInstance();
    return {
      'staffId': pref.getString('staffId') as String,
      'name': pref.getString('name') as String,
      'email': pref.getString('email') as String,
      'department': pref.getString('department') as String,
      'currentYear': pref.getString('currentYear') as String,
      'studentBatch': pref.getString('studentBatch') as String,
      'semester': pref.getString('semester') as String,
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
            print(snapshot.data);
            final data = snapshot.data as Map<String, dynamic>;
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'ID ',
                            style: style,
                          ),
                          Text('Name ', style: style),
                          Text('Email ', style: style),
                          Text('Department ', style: style),
                          Text('CurrentYear ', style: style),
                          Text('Semester ', style: style),
                          Text('Section ', style: style),
                          Text('StudentBatch ', style: style),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(': ${data['staffId']}', style: style),
                          Text(': ${data['name']}', style: style),
                          Text(': ${data['email']}', style: style),
                          Text(': ${data['department']}', style: style),
                          Text(': ${data['currentYear']}', style: style),
                          Text(': ${data['semester']}', style: style),
                          Text(': ${data['section']}', style: style),
                          Text(': ${data['studentBatch']}', style: style),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: data['students'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: Text(data['students'][index]),
                        );
                      }),
                )
              ],
            );
          } else if (snapshot.hasData) {
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
