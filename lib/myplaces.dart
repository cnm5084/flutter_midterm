// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_midterm/places.dart';
import 'package:http/http.dart' as http;

class Myplaces extends StatefulWidget {
  const Myplaces({super.key});

  @override
  State<Myplaces> createState() => _MyplacesState();
}

class _MyplacesState extends State<Myplaces> {
  List<Place> placeList = [];
  String status = "Press the button to get place.";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600; //limit max width for better readability
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Place', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 136, 156, 113),
      ),
      body: Center(
        child: isLoading
            ? Column(
                children: [
                  SizedBox(height: 100, child: Center(child: Text(status))),
                  CircularProgressIndicator(),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Let\'s explore Malaysia!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        getPlace();
                      },
                      child: Text('Explore random place.'),
                    ),
                  ),
                  SizedBox(height: 10),
                  placeList.isEmpty
                      ? SizedBox(
                          height: 100,
                          child: Center(child: Text(status)),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: placeList.length,
                            itemBuilder: (context, index) {
                              Place place = placeList[index];
                              return SizedBox(
                                height: 220,
                                child: Card(
                                  elevation: 2,
                                  shadowColor: const Color.fromARGB(255,103,102,133,),
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 15),
                                      Center(
                                        child: Container(
                                          width: 150,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(255,27,41,28,),
                                            ),
                                          ),
                                          child: Image.network(
                                            place.imageUrl,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Text(
                                              place.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Text('State: $place.state',
                                            style: TextStyle(fontSize: 16),),
                                            Text('Rating: $place.rating',
                                            style: TextStyle(fontSize: 16),),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(place.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  content: SizedBox(
                                                    width: double.maxFinite,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:CrossAxisAlignment.start,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              width: 250,
                                                              height: 280,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color:
                                                                      const Color.fromARGB( 255,27,41,28,),
                                                                ),
                                                              ),
                                                              child: Image.network(
                                                                place.imageUrl,
                                                                width: 250,
                                                                height: 280,
                                                                fit: BoxFit.cover,
                                                                errorBuilder:
                                                                    (context,error,stackTrace) => const Icon(
                                                                      Icons.error,color: Colors.red,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text('Description: ',style: TextStyle(fontWeight:FontWeight.bold),),
                                                          Text(place.description),
                                                          SizedBox(height: 5),
                                                          Text('Contact: ',style: TextStyle(fontWeight:FontWeight.bold,),),
                                                          Text(place.contact),
                                                          SizedBox(height: 5,),
                                                          Text('Location: ',
                                                            style: TextStyle(fontWeight:FontWeight.bold),),
                                                          Text('Latitude: $place.latitude'),
                                                          Text('Longitude: $place.longitude '),
                                                          SizedBox(height: 5,),
                                                          Text('Category: ',style: TextStyle(fontWeight:FontWeight.bold),),
                                                          Text(place.category),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context,).pop(),
                                                      child: const Text(
                                                        'Close',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
      ),
    );
  }

 void getPlace() async {
  placeList = [];
  isLoading = true;
  setState(() {});

  status = "Fetching places...";

  try {
    final response = await http
        .get(
          Uri.parse(
            'https://slumberjer.com/teaching/a251/locations.php?state=&category=&name=',
          ),
        )
        .timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            print('Error getting places: Timeout');
            status = 'Error getting places: Timeout';
            isLoading = false;
            setState(() {});
            return http.Response('Error', 408); // return timeout response
          },
        );

    if (response.statusCode != 200) {
      print('Error getting places: ${response.statusCode}');
      status = 'Error getting places: ${response.statusCode}';
      isLoading = false;
      setState(() {});
      return;
    }

    if (response.body.isEmpty) {
      print('Error getting places: Empty response');
      status = 'Error getting places: Empty response';
      isLoading = false;
      setState(() {});
      return;
    }

    if (response.body.contains('error')) {
      print('Error getting places: ${response.body}');
      status = 'Error getting places: ${response.body}';
      isLoading = false;
      setState(() {});
      return;
    }

    final data = json.decode(response.body);

    if (data is! List || data.isEmpty) {
      print('Error getting places: No data found');
      status = 'No places found.';
      placeList = [];
      isLoading = false;
      setState(() {});
      return;
    }
    
    placeList = data.map<Place>((item) => Place.fromJson(item)).toList();
    status = 'Places loaded successfully.';
  } catch (error) {
    print('Error getting places: $error');
    status = 'Connection error. Please check your internet.';
  } finally {
    isLoading = false;
    setState(() {});
  }
}

}
