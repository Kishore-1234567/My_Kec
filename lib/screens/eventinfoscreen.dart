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
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text('Organizer : ${event['eventOrganizer']}'),
                  const SizedBox(height: 10),
                  Text('Date : ${event['dateOfEvent']}'),
                  const SizedBox(height: 10),
                  Text(
                      'Registration DeadLine : ${event['registrationDeadLine']}'),
                  const SizedBox(height: 10),
                  Text('Entry Fee : ${event['entryFee']}'),
                  const SizedBox(height: 10),
                  const Text('Description : '),
                  Text('    ${event['eventDescription']}'),
                  const SizedBox(height: 10),
                  const Text(
                      'Coordinators : '), // + e.coordinators.toString()),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Something went Wrong')));
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
          ]))
        ],
      ),
    );
  }
}
