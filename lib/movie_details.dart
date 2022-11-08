import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import './home_screen.dart';
import './models/mcu_models.dart';

class MovieDetails extends StatefulWidget {
  MovieDetails({super.key, required this.index});
  final int index;

  @override
  State<MovieDetails> createState() => MovieDetailsState(index: index);
}

class MovieDetailsState extends State<MovieDetails> {
  List<McuModels> mcuMoviesList = [];

  MovieDetailsState({required this.index});
  final int index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMarvelMovies();
    print('$index do filme');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 23, 23),
      body: mcuMoviesList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, -20),
                                  spreadRadius: 1,
                                  blurRadius: 30,
                                  color: Color.fromARGB(2, 255, 255, 255)
                                      .withOpacity(0.5),
                                )
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60)),
                            child: Container(
                              width: size.width,
                              height: size.height * .6,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:
                                    mcuMoviesList[index].coverUrl.toString(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: IconButton(
                            iconSize: 30,
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: (() => Navigator.pop(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * .9,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mcuMoviesList[index].title.toString(),
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            mcuMoviesList[index].overview.toString() != "null"
                                ? mcuMoviesList[index].overview.toString()
                                : "There's no overview yet.",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white60),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Director: " +
                                mcuMoviesList[index].directedBy.toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white60),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Release Date: " +
                                mcuMoviesList[index].releaseDate.toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white60),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Duration: " +
                                mcuMoviesList[index].duration.toString() +
                                " min",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white60),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => launch(
                                  mcuMoviesList[index].trailerUrl.toString()),
                              child: Text(
                                "ASSISTA O TRAILER",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
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
      } else {}
      setState(() {});
    }).catchError((err) {
      debugPrint('======== $err =========');
    });
  }
}
