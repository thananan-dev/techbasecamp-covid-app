import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Score extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        //resizeToAvoidBottomInset: false,
        body: ScoreScreen(),
      ),
    );
  }
}

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  int _confirmed = 0;
  int _deaths = 0;
  int _hospitalized = 0;

  int _globalConfirmed = 0;
  int _globalDeaths = 0;

  Future<List> callAPI() async {
    var apiThai = 'https://covid19.th-stat.com/api/open/today';
    var apiGlobal = 'https://covid19.mathdro.id/api';

    await http.get(apiThai).then((value) {
      var getState = convert.jsonDecode(value.body);
      _confirmed = getState["Confirmed"];
      _deaths = getState["Deaths"];
      _hospitalized = getState["Hospitalized"];
    });

    await http.get(apiGlobal).then((value) {
      var getState = convert.jsonDecode(value.body);
      _globalConfirmed = getState['confirmed']['value'];
      _globalDeaths = getState['deaths']['value'];
      print(getState['deaths']['value']);
    });

    var list = [
      _confirmed,
      _deaths,
      _hospitalized,
      _globalConfirmed,
      _globalDeaths
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: callAPI(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.only(top: 40),
                  color: Colors.white,
                  child: Center(
                      child: Center(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(50),
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.amber,
                            child: Image.asset('assets/scoreImage/location.png',
                                fit: BoxFit.contain),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 100, left: 10, right: 10),
                            child: Column(
                              children: [
                                // ============================================= UPPER CONTAINER =============================================
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Wow");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            )
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            // ++++++++++++++++++++++++++++++++++++ LABEL ++++++++++++++++++++++++++++++++++++
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.all(0),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "World Covid statistics",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 28,
                                                          color:
                                                              Colors.grey[800]),
                                                    ),
                                                  ),
                                                )),

                                            // ################################# BOX #################################
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey))),
                                                        child: Center(
                                                          child: Text(snapshot
                                                              .data[3]
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        color: Colors.white12,
                                                        child: Center(
                                                          child: Text(snapshot
                                                              .data[4]
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // ============================================= LOWER CONTAINER =============================================
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      //color: Colors.black12,
                                      child: Column(
                                        children: [
                                          // ++++++++++++++++++++++++++++++++++++ LABEL ++++++++++++++++++++++++++++++++++++
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "Thailand",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28,
                                                      color: Colors.grey[800]),
                                                ),
                                              )),

                                          // ################################# BOX #################################
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3),
                                                  )
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      //color: Colors.red,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Container(
                                                          color: Colors
                                                              .greenAccent,
                                                          child: Center(
                                                            child: Text(snapshot
                                                                .data[0]
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      //color: Colors.red,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Container(
                                                          color: Colors
                                                              .greenAccent,
                                                          child: Center(
                                                            child: Text(snapshot
                                                                .data[1]
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      //color: Colors.red,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Container(
                                                          color: Colors
                                                              .greenAccent,
                                                          child: Center(
                                                            child: Text(snapshot
                                                                .data[2]
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
            else if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}