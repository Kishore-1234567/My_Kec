import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_kec/api/apis.dart';
import 'package:my_kec/screens/alleventsscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../widgets/eventcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currenpos = 0;

  void openPDF(BuildContext ctx, String url) async {
    launchUrl(Uri.parse(url));
  }

  Future<List<dynamic>> getEvents() async {
    final response = await http.get(Uri.https(DOMAIN_NAME, GETEVENTS));
    return jsonDecode(response.body);
  }

  Future<List<Map<String, String>>> getCirculars() async {
    final response2 = await http.get(Uri.https(DOMAIN_NAME, GETCIRCULAR));
    var data = jsonDecode(response2.body);
    List<Map<String, String>> circular = [];
    for (var i in data) {
      circular.add({
        'circularNumber': i['circularNumber'],
        'circularTitle': i['circularTitle'],
        'circularDescription': i['circularDescription'],
        'documentLink': i['documentLink'],
        'timeStamp': i['timeStamp'],
        'userCategory': i['userCategory'],
      });
    }
    circular = circular
        .where((element) =>
            (element['userCategory'] == '0' ||
                element['userCategory'] == '1') &&
            (DateTime.parse(element['timeStamp'].toString())
                .isAfter(DateTime.now().subtract(const Duration(days: 30)))))
        .toList();
    return circular.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Events ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => AllEventsScreen()));
                  },
                  child: const Text('View All'))
            ],
          ),
        ),
        FutureBuilder(
            future: getEvents(),
            builder: (ctx, ss) {
              if (ss.hasData) {
                final list = ss.data as List<dynamic>;
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 50,
                    child: Text('Temporarily there is no Events '),
                  );
                }
                return SizedBox(
                  child: CarouselSlider.builder(
                    itemCount: list.length,
                    options: CarouselOptions(
                      pauseAutoPlayOnTouch: true,
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    itemBuilder: (context, index, i) {
                      return EventCard(event: list[index]);
                    },
                  ),
                );
              }
              if (ss.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        Expanded(
            child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
              future: getCirculars(),
              builder: (ctx, ss) {
                if (ss.hasData) {
                  final circular = ss.data as List<Map<String, String>>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: circular.length,
                      itemBuilder: ((context, index) => Card(
                            elevation: 7,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Cicular No : ${circular[index]['circularNumber'] as String}\n${circular[index]['circularTitle'] as String}'),
                                  ElevatedButton(
                                      onPressed: () {
                                        try {
                                          launchUrl(Uri.parse(circular[index]
                                              ['documentLink'] as String));
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Something went wrong')));
                                        }
                                      },
                                      child: const Text('View'))
                                ],
                              ),
                            ),
                          )),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ))
      ],
    );
  }
}
