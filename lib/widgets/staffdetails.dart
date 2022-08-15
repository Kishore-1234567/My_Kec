
import 'package:flutter/material.dart';

class StaffDetails extends StatelessWidget {
  const StaffDetails({
    Key? key,
    required this.style,
    required this.data,
  }) : super(key: key);

  final TextStyle style;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}