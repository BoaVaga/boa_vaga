import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

final List<String> imgList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6U_U_wC1S1A8cBSPHGhgRDcf2V1U56lZntw&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsQMD02euy61wBhey8NwL42Pc-MNTv5nMZx25lFZHTi0LNjUC-Tl4jOdwPduC8X_wmHuQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtKtTC2VBJV9e2q2qVfYvcQ0t-JJupzr2yu2UzajLM37TjX2HkApTuTM2mgqhokSDFGME&usqp=CAU'
];

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
  final ScrollController _firstController = ScrollController();

  String location = 'Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /*

Text(
              'Coordinates Points',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              location,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'ADDRESS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text('$Address'),
            ElevatedButton(
                onPressed: () async {
                  Position position = await _getGeoLocationPosition();
                  print(position);
                },
                child: Text('Get Location'))

  */

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
            new Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Estacionamentos',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            new Container(
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
                        hintText: 'Buscar'))),
            new Container(
              margin: const EdgeInsets.only(top: 30.0, left: 10.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Sugeridos por sua localização',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
            ),
            new Container(
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
                  items: imgList
                      .map((item) => Container(
                              child: Center(
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PageEstacionamento()),
                                  );
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    )),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0)),
                                                child: Image.network(item,
                                                    fit: BoxFit.cover,
                                                    width: 1000)),
                                          ),
                                          Row(children: <Widget>[
                                            Expanded(
                                                flex: 5,
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 15.0,
                                                              right: 15.0,
                                                              bottom: 10.0),
                                                      child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(
                                                              'Click Vagas',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                    ))),
                                            Expanded(
                                                flex: 5,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 15.0,
                                                              right: 15.0,
                                                              bottom: 10.0),
                                                      child: Text(
                                                          '(16) 99791-1430',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                )),
                                          ]),
                                        ]))),
                          )))
                      .toList(),
                )),
            Row(children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Text('Mais estacionamentos',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                  )),
              Expanded(
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
                  )),
            ]),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(5),
                height: 400,
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _firstController,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: ListTile(
                          leading: FlutterLogo(size: 72.0),
                          title: Text('Estacionamento do seu Zé'),
                          subtitle: Text('O + brabo de araraquara'),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageEstacionamento()),
                            );
                          },
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageEstacionamento extends StatelessWidget {
  const PageEstacionamento({Key? key}) : super(key: key);

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
                items: imgList
                    .map((item) => Container(
                            child: Center(
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                Expanded(
                                  child: Image.network(item,
                                      fit: BoxFit.cover, width: 1000),
                                ),
                              ])),
                        )))
                    .toList(),
              )),
          new Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('Click Vagas - Araraquara',
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                    'Endereço: Rua do seu zé\nNº 549, Carmo, Araraquara - SP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('Telefone: (16) 99791-1430',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15))),
          ),
          Expanded(
            child: new Container(
              margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                      'Descrição: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tempor, nunc ac sollicitudin tempor, nulla lorem mollis lectus, nec rhoncus tellus metus eu sem. Donec venenatis mi eget turpis porttitor, eu finibus lectus dictum. Vestibulum id quam sed leo ullamcorper fermentum at sit amet dui. Cras vehicula magna et urna tempor, sit amet porta sapien suscipit. Proin leo diam, varius eu justo eu, maximus facilisis justo. Pellentesque varius varius velit, id interdum neque tincidunt finibus.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15))),
            ),
          ),
          Container(
              child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Voltar', style: TextStyle(fontSize: 18)),
          ))
        ])));
  }
}
