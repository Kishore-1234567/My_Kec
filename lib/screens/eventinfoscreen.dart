import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsInfoScreen extends StatelessWidget {
  var event;
  EventsInfoScreen({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var coordinatorNameList = event['coordinatorName'].toString().split(',');
    var coordinatorNumberList =
        event['coordinatorNumber'].toString().split(',');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event['eventName'] as String,
              ),
              background: Hero(
                tag: event['eventName'] as String,
                child: SizedBox(
                  height: 200,
                  child: Image.memory(
                    base64Decode(
                      event['eventImage'] as String,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          EventDetail(
              event: event,
              coordinatorNameList: coordinatorNameList,
              coordinatorNumberList: coordinatorNumberList)
        ],
      ),
    );
  }
}

class EventDetail extends StatelessWidget {
  const EventDetail({
    Key? key,
    required this.event,
    required this.coordinatorNameList,
    required this.coordinatorNumberList,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final event;
  final List<String> coordinatorNameList;
  final List<String> coordinatorNumberList;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextSpanWidget(
              heading: 'Organizer : ',
              description: event['eventOrganizer'],
            ),
            const SizedBox(height: 10),
            TextSpanWidget(
              heading: 'Date : ',
              description: event['dateOfEvent'],
            ),
            const SizedBox(height: 10),
            TextSpanWidget(
              heading: 'Registration DeadLine : ',
              description: event['registrationDeadLine'],
            ),
            const SizedBox(height: 10),
            TextSpanWidget(
              heading: 'Entry Fee : ',
              description: event['entryFee'],
            ),
            const SizedBox(height: 10),
            const Text('Description : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(event['eventDescription']),
            const SizedBox(height: 10),
            const Text('Coordinators : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(
              height: coordinatorNameList.length * 30,
              child: ListView.builder(
                  reverse: true,
                  itemCount: coordinatorNameList.length,
                  itemBuilder: (ctx, i) {
                    String key = coordinatorNameList[i];
                    return SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Text('    $key'),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(':'),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton(
                              onPressed: () {
                                try {
                                  launchUrl(Uri.parse(
                                      'tel://${coordinatorNumberList[i]}'));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Something went Wrong')));
                                }
                              },
                              child: Text(coordinatorNumberList[i]))
                        ],
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      )
    ]));
  }
}

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
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          TextSpan(
            text: '\n\t\t\t\t$description',
          ),
        ],
      ),
    );
  }
}
