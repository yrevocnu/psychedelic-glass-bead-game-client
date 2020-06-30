import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Deck.dart';
import 'ApiService.dart';

void main() {
  runApp(App());
}

var client = http.Client();

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<List<Deck>> decks;
  Future<Card> card;

  @override
  void initState() {
    super.initState();

    decks = ApiService().fetchDecks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Psychedelic Glass Bead Game',
        theme: ThemeData(
          primaryColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('Psychedelic Glass Bead Game')),
          backgroundColor: Colors.black,
          body: Center(
            child: FutureBuilder<List<Deck>>(
              future: decks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        for (var deck in snapshot.data)
                          Column(children: [
                            ButtonTheme(
                                minWidth: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.white)),
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text(deck.name),
                                  onPressed: () {
                                    ApiService().draw(deck.name).then((card) {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: 'Overlay',
                                        barrierColor: Colors.black,
                                        transitionDuration:
                                            Duration(milliseconds: 100),
                                        pageBuilder: (_, __, ___) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                card.name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(card.description,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                              SizedBox(height: 10),
                                              Image.network(
                                                'https://pgbg.herokuapp.com/decks/${deck.name.toLowerCase()}/${card.image}',
                                              ),
                                              RaisedButton(
                                                  child: Text('Dismiss'),
                                                  onPressed: () =>
                                                      Navigator.pop(context))
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                )),
                            Text(
                              deck.description,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 50)
                          ]),
                        RaisedButton(
                            color: Colors.red,
                            onPressed: () {},
                            child: Text('New Game')),
                      ]);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
