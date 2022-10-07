import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_kec/widgets/eventcard.dart';
import 'package:http/http.dart' as http;

import '../api/apis.dart';

class AllEventsScreen extends StatefulWidget {
  AllEventsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  Future<List<dynamic>> getEvents() async {
    final response = await http.get(Uri.https(DOMAIN_NAME, GETEVENTS));
    return jsonDecode(response.body);
  }

  List<String> categoryList = ['Inside', 'Outside', 'Others', 'All'];

  String category = 'All';

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Events', style: TextStyle(color: Colors.black))),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter Events',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                DropdownButton(
                    dropdownColor: brightness == Brightness.dark
                        ? const Color.fromARGB(255, 59, 59, 59)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    value: category,
                    icon: const Icon(Icons.filter_alt_sharp),
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
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went Wrong'),
                    );
                  }
                  if (snapshot.hasData) {
                    final list = snapshot.data as List<dynamic>;
                    var eventlist;
                    if (category == 'Inside') {
                      eventlist = list
                          .where((element) => element['eventCategory'] == '1')
                          .toList();
                    } else if (category == 'Outside') {
                      eventlist = list
                          .where((element) => element['eventCategory'] == '2')
                          .toList();
                    } else if (category == 'Others') {
                      eventlist = list
                          .where((element) => element['eventCategory'] == '3')
                          .toList();
                    } else {
                      eventlist = list;
                    }
                    return eventlist.length == 0
                        ? const Center(
                            child: Text('Temporarily there is no events '))
                        : ListView.builder(
                            itemCount: eventlist.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: EventCard(event: eventlist[index]));
                            });
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
