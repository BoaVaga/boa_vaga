import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MyApp());
}

class GQlConfiguration {
  static HttpLink httplink = HttpLink(
    "http://192.168.0.114:5000/graphql",
  );

  GraphQLClient myQlClient() {
    return GraphQLClient(link: httplink, cache: GraphQLCache());
  }
}

class Queries {
  buscarEstacioProx(lat, long) {
    return '''query ProcurarEstacio {
  buscarEstacio(coordenadas: "POINT($lat $long)") {
    success
    error
    estacionamentos {
      id
      nome
      telefone
      endereco {
        logradouro
        estado
        cidade
        bairro
        numero
        cep
        coordenadas
    	}
      foto
      estaSuspenso
      estaAberto
      cadastroTerminado
      descricao
      qtdVagaLivre
      totalVaga
      horarioPadrao {
        segundaAbr
        segundaFec
        tercaAbr
        tercaFec
      }
      valoresHora {
        id
        valor
        veiculo
      }
      horasDivergentes {
        id
        data
        horaAbr
        horaFec
      }
    }
  }
}''';
  }

  buscarTodosEstacionamentos() {
    return '''query ProcurarEstacio {
  listEstacionamento {
    success
    error
    estacionamentos {
      id
      nome
      telefone
      endereco {
        logradouro
        estado
        cidade
        bairro
        numero
        cep
        coordenadas
    	}
      foto
      estaSuspenso
      estaAberto
      cadastroTerminado
      descricao
      qtdVagaLivre
      totalVaga
      horarioPadrao {
        segundaAbr
        segundaFec
        tercaAbr
        tercaFec
        quartaAbr
				quartaFec
				quintaAbr
				quintaFec				
				sextaAbr				
				sextaFec
				sabadoAbr
				sabadoFec
				domingoAbr
				domingoFec
      }
      valoresHora {
        id
        valor
        veiculo
      }
      horasDivergentes {
        id
        data
        horaAbr
        horaFec
      }
    }
  }
}''';
  }
}

final List<String> imgListTemp = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6U_U_wC1S1A8cBSPHGhgRDcf2V1U56lZntw&usqp=CAU',
];

final List<int> estacioProxList = [];
final List<int> listTodosEstacio = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remover dps, bandeira modo debug
      title: 'Boa Vaga',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(240, 255, 255, 255), // Ligth
        // scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255), // Branco
        // scaffoldBackgroundColor: Color.fromRGBO(35, 35, 35, 1), // Cinza Escuro
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  final ScrollController controllerScroll = ScrollController();
  var jsonRespostaEstacioProx;
  var jsonRespostaTodosEstacio;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Position(longitude: 1, latitude: 1, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Position(longitude: 1, latitude: 1, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Position(longitude: 1, latitude: 1, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logonometransparente.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            /*new Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                        fillColor: Color.fromARGB(20, 20, 20, 20),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 32.0,
                        ),
                        hintText: 'Buscar'))),*/ // Barra de pesquisa
            new FutureBuilder<bool>(
              future: buscarEstacioProx(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('');
                  default:
                    if (!snapshot.hasError) {
                      if (estacioProxList.length == 0) {
                        return Text("");
                      }
                      return Container(
                          child: Column(children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                          child: Align(alignment: Alignment.topLeft, child: Text('Estacionamentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        ),
                        new Container(
                          margin: const EdgeInsets.only(top: 30.0, left: 10.0),
                          child: Align(alignment: Alignment.topLeft, child: Text('Sugeridos por sua localização', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 180.0,
                                initialPage: 0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: Duration(milliseconds: 3000),
                                viewportFraction: 0.8,
                              ),
                              items: estacioProxList
                                  .map((item) => Container(
                                          child: Center(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PageEstacionamento(dados: jsonRespostaEstacioProx["buscarEstacio"]["estacionamentos"][item])),
                                              );
                                            },
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: const BorderRadius.all(
                                                  Radius.circular(15.0),
                                                )),
                                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                                  Expanded(
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                                        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6U_U_wC1S1A8cBSPHGhgRDcf2V1U56lZntw&usqp=CAU", fit: BoxFit.cover, width: 1000)),
                                                  ),
                                                  Row(children: <Widget>[
                                                    Expanded(
                                                        flex: 5,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Container(
                                                              margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                                                              child: FittedBox(
                                                                  fit: BoxFit.contain, child: Text(jsonRespostaEstacioProx["buscarEstacio"]["estacionamentos"][item]["nome"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                                                            ))),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Align(
                                                          alignment: Alignment.topRight,
                                                          child: Container(
                                                              margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                                                              child: Text(jsonRespostaEstacioProx["buscarEstacio"]["estacionamentos"][item]["telefone"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                                                        )),
                                                  ]),
                                                ]))),
                                      )))
                                  .toList(),
                            ))
                      ]));
                    } else
                      return new Text('Erro: ${snapshot.error}');
                }
              },
            ),
            Row(children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(margin: const EdgeInsets.only(top: 10.0, left: 10.0), child: Text('Todos os estacionamentos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  )),
              /*Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list_rounded,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          tooltip: 'Filtros',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Aqui vai os filtros',
                                        textAlign: TextAlign.center)));
                          },
                        )),
                  )),*/ // Aqui vai os filtros
            ]),
            new FutureBuilder<bool>(
              future: buscarTodosEstacio(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Aguarde');
                  default:
                    if (!snapshot.hasError) {
                      if (listTodosEstacio.length == 0) {
                        return Text("Nenhum estacionamento encontrado");
                      }
                      return Flexible(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          height: 1000,
                          width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: controllerScroll,
                              itemCount: listTodosEstacio.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                  child: ListTile(
                                    leading: FlutterLogo(size: 72.0),
                                    title: Text(jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"][index]["nome"]),
                                    subtitle: Text('Vagas disponíveis: ' + jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"][index]["qtdVagaLivre"].toString()),
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PageEstacionamento(dados: jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"][index])),
                                      );
                                    },
                                  ),
                                );
                              }),
                        ),
                      );
                    } else
                      return new Text('Erro: ${snapshot.error}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> buscarEstacioProx() async {
    Position position = await _getGeoLocationPosition();

    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.query(QueryOptions(document: gql(_queries.buscarEstacioProx(position.latitude, position.longitude))));

    if (result.hasException)
      return false;
    else {
      jsonRespostaEstacioProx = result.data;
      for (var i = 0; i < jsonRespostaEstacioProx["buscarEstacio"]["estacionamentos"].length; i++) {
        estacioProxList.add(i);
      }
      return true;
    }
  }

  Future<bool> buscarTodosEstacio() async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.query(QueryOptions(document: gql(_queries.buscarTodosEstacionamentos())));

    if (result.hasException)
      return false;
    else {
      jsonRespostaTodosEstacio = result.data;
      for (var i = 0; i < jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"].length; i++) {
        listTodosEstacio.add(i);
      }
      return true;
    }
  }
}

class PageEstacionamento extends StatelessWidget {
  final dados;
  const PageEstacionamento({Key? key, required this.dados}) : super(key: key);

  String get estaAberto => dados["estaAberto"] ? "Sim" : "Não";
  String get estaSuspenso => dados["estaSuspenso"] ? "Sim" : "Não";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logonometransparente.png',
                fit: BoxFit.contain,
                height: 40,
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            child: Column(children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                ),
                items: imgListTemp
                    .map((item) => Container(
                            child: Center(
                          child: Card(
                              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            Expanded(
                              child: Image.network(item, fit: BoxFit.cover, width: 1000),
                            ),
                          ])),
                        )))
                    .toList(),
              )),
          new Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Align(alignment: Alignment.topCenter, child: Text(dados["nome"], style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Endereço: " + dados["endereco"]["logradouro"] + "\nNº " + dados["endereco"]["numero"] + ", " + dados["endereco"]["bairro"] + ", " + dados["endereco"]["cidade"] + ' - ' + dados["endereco"]["estado"],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Align(alignment: Alignment.topCenter, child: Text('Telefone: ' + dados["telefone"], textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Descrição: " + dados["descricao"] + dados["descricao"] + dados["descricao"] + dados["descricao"] + dados["descricao"] + dados["descricao"], textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Aberto: " + estaAberto + "\n Suspenso: " + estaSuspenso + "\n Vagas Livres: " + dados["qtdVagaLivre"].toString() + " / " + dados["totalVaga"].toString(),
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                    "Horário de Funcionamento: \n Segunda-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["segundaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["segundaFec"]) +
                        "\n Terça-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["tercaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["tercaFec"]) +
                        "\n Quarta-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["quartaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["quartaFec"]) +
                        "\n Quinta-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["quintaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["quintaFec"]) +
                        "\n Sexta-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["sextaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["sextaFec"]) +
                        "\n Sábado: " +
                        formatHHMMSS(dados["horarioPadrao"]["sabadoAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["sabadoFec"]) +
                        "\n Domingo: " +
                        formatHHMMSS(dados["horarioPadrao"]["domingoAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["domingoFec"]),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15))),
          ),
          new Container(
              margin: const EdgeInsets.only(top: 25.0, bottom: 5.0),
              child: Center(
                child: Text("Valores"),
              )),
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical, // Axis.horizontal for horizontal list view.
              itemCount: dados["valoresHora"].length,
              itemBuilder: (ctx, index) {
                return Align(child: Text("Tipo: " + dados["valoresHora"][index]["veiculo"] + "   Valor: " + dados["valoresHora"][index]["valor"]));
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 15.0, bottom: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Voltar', style: TextStyle(fontSize: 18)),
              ))
        ])));
  }
}

mostrarAlertDialogErro(BuildContext context, msgErro) {
  Widget okButton = ElevatedButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alerta = AlertDialog(
    title: Text("Erro"),
    content: Text(msgErro),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

String formatHHMMSS(int seconds) {
  if (seconds != 0) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }
    return "$hoursStr:$minutesStr:$secondsStr";
  } else {
    return "";
  }
}
