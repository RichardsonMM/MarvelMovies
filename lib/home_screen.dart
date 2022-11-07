import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_api/models/mcu_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<McuModels> mcuMoviesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarvelMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: IconButton(
                icon: Icon(Icons.menu_rounded),
                splashRadius: 20,
                onPressed: () {}),
          ),
          Spacer(),
          Center(
            child: Text(
              'Marvel Movies',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {}, icon: Icon(Icons.settings), splashRadius: 20),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 23, 23, 23),
      body: mcuMoviesList.isNotEmpty
          ? GridView.builder(
              itemCount: mcuMoviesList.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.8 / 3.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 50,
                  height: 100,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: CachedNetworkImage(
                          imageUrl: mcuMoviesList[index].coverUrl.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset('images/1841128648.jpg'),
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: Text(
                          mcuMoviesList[index].title.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Container(
              width: 50,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white70),
              ),
            ),
    );
  }

  void getMarvelMovies() {
    debugPrint('========== Function running ===========');
    final uri = Uri.parse('https://mcuapi.herokuapp.com/api/v1/movies');
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        final marvelData = decodedData['data'];
        for (var i = 0; i < marvelData.length; i++) {
          final mcuMovie =
              McuModels.fromJson(marvelData[i] as Map<String, dynamic>);
          mcuMoviesList.add(mcuMovie);
        }
        setState(() {});
      } else {}
    }).catchError((err) {
      debugPrint('======== $err =========');
    });
  }

  void getMcuData() {}
}
