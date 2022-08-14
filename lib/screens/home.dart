import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_kec/screens/eventinfoscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
    final response = await http.get(Uri.https(
        'mykecerode.000webhostapp.com', '/AppApi/Staff/getevents.php'));
    var data = jsonDecode(response.body);
    return data;
  }

  Future<List<Map<String, String>>> getCirculars() async {
    final pref = await SharedPreferences.getInstance();
    String department = pref.getString('department')!;
    final response = await http.get(Uri.https(
        "mykecerode.000webhostapp.com", "AppApi/Staff/getcircular.php"));
    var data = jsonDecode(response.body);
    List<Map<String, String>> circular = [];
    for (var i in data) {
      circular.add({
        'circularNumber': i['circularNumber'],
        'circularTitle': i['circularTitle'],
        'circularDescription': i['circularDescription'],
        'department': i['department'],
        'documentLink': i['documentLink'],
        'timeStamp': i['timeStamp']
      });
    }
    circular = circular
        .where((element) =>
            element['department'].toString().contains(department))
        .toList();
    return circular.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: getEvents(),
            builder: (ctx, ss) {
              if (ss.hasData) {
                final list = ss.data as List<dynamic>;
                if (list.isEmpty) {
                  return const SizedBox(
                    height: 100,
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
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      EventsInfoScreen(event: list[index])));
                        },
                        child: Hero(
                          tag: list[index],
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: MemoryImage(base64Decode(
                                      list[index]['eventImage'] as String,
                                    )),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        Expanded(
            child: FutureBuilder(
                future: getCirculars(),
                builder: (ctx, ss) {
                  if (ss.hasData) {
                    final circular = ss.data as List<Map<String, String>>;
                    return ListView.builder(
                      itemCount: circular.length,
                      itemBuilder: ((context, index) => Card(
                            elevation: 7,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Cicular No : ${circular[index]['circularNumber'] as String}\n${circular[index]['circularTitle'] as String}'),
                                  ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          launchUrl(Uri.parse(circular[index]
                                              ['documentLink'] as String));
                                        } catch (e) {
                                          // show
                                        }
                                      },
                                      child: const Text('View'))
                                ],
                              ),
                            ),
                          )),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }))
      ],
    );
  }
}
