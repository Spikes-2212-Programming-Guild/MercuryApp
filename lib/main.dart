import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:requests/requests.dart';
import 'dart:io';

const spikesBlue = Color.fromARGB(255, 46, 51, 136);
const bodyText = TextStyle(fontSize: 16);
const titleText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const formId = "1FAIpQLSe-JL9U4rAaltuocdbKeNtAjcimn-jdOB3InTzoepJfWkL2gQ";
final formParamaters = [
  "entry.1672695657",
  "entry.629299808",
  "entry.114185292",
];

abstract class ScouterStats {
  static String name = "";
  static int team = 0;
  static bool isBlueAlliance = false;
  static DateTime lastTimeSubmited = DateTime.fromMicrosecondsSinceEpoch(42);
}

abstract class AutonomousStats {
  static int blueCargoScored = 0;
}

abstract class GameStats {
  static int blueCargoScored = 0;
  static int redCargoScored = 0;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Tab> _tabs = const [
    Tab(text: "Info"),
    Tab(text: "Auto"),
    Tab(text: "Teleop"),
    Tab(text: "Submit"),
  ];

  @override
  Widget build(BuildContext context) {
    InfoPage infoPage = const InfoPage();

    return MaterialApp(
      home: DefaultTabController(
        length: _tabs.length,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("DCMP"),
              centerTitle: true,
              backgroundColor: spikesBlue,
              bottom: TabBar(
                tabs: _tabs,
              ),
            ),
            body: TabBarView(
              children: [
                infoPage,
                const AutonomousPage(padding: 8.0),
                const DataPage(),
                const SubmitPage(padding: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [
          BlueCargoScoredWidget(
            padding: 8.0,
          ),
          RedCargoStoredWidget(
            padding: 8.0,
          ),
        ],
      ),
    );
  }
}

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);
  final int hello = 10;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            autocorrect: false,
            controller: TextEditingController(),
            onChanged: (value) => ScouterStats.name = value,
            decoration: const InputDecoration(
              label: Text("Name"),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            controller: TextEditingController(),
            decoration: const InputDecoration(
              label: Text("Scouted Team"),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              try {
                ScouterStats.team = int.parse(value);
              } on FormatException catch (_) {
                ScouterStats.team = -1;
              }
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Alliance: ", style: bodyText),
              ToggleSwitch(
                labels: const ['Red', 'Blue'],
                initialLabelIndex: 0,
                activeBgColors: const [
                  [Colors.red],
                  [Colors.blue],
                ],
                onToggle: (index) =>
                    ScouterStats.isBlueAlliance = !ScouterStats.isBlueAlliance,
              )
            ],
          )
        ],
      ),
    );
  }
}

class BlueCargoScoredWidget extends StatefulWidget {
  const BlueCargoScoredWidget({Key? key, required this.padding})
      : super(key: key);

  final double padding;

  @override
  State<BlueCargoScoredWidget> createState() => _BlueCargoScoredWidgetState();
}

class _BlueCargoScoredWidgetState extends State<BlueCargoScoredWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: SpinBox(
        min: 0,
        decoration: const InputDecoration(labelText: "Blue Cargo Scored"),
        value: GameStats.blueCargoScored.toDouble(),
        onChanged: (value) => setState(
          () => GameStats.blueCargoScored.toInt(),
        ),
      ),
    );
  }
}

class RedCargoStoredWidget extends StatefulWidget {
  const RedCargoStoredWidget({Key? key, required this.padding})
      : super(key: key);

  final double padding;

  @override
  State<RedCargoStoredWidget> createState() => _RedCargoStoredWidgetState();
}

class _RedCargoStoredWidgetState extends State<RedCargoStoredWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: SpinBox(
        min: 0,
        decoration: const InputDecoration(labelText: "Red Cargo Scored"),
        value: GameStats.redCargoScored.toDouble(),
        onChanged: (value) => setState(
          () => GameStats.redCargoScored = value.toInt(),
        ),
      ),
    );
  }
}

class AutonomousPage extends StatefulWidget {
  final double padding;

  const AutonomousPage({Key? key, required this.padding}) : super(key: key);

  @override
  State<AutonomousPage> createState() => _AutonomousPageState();
}

class _AutonomousPageState extends State<AutonomousPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Column(
        children: [
          SpinBox(
            decoration: const InputDecoration(labelText: "Blue Cargo"),
            min: 0,
            step: 1,
            value: AutonomousStats.blueCargoScored.toDouble(),
            onChanged: (value) =>
                AutonomousStats.blueCargoScored = value.toInt(),
          ),
        ],
      ),
    );
  }
}

class SubmitPage extends StatefulWidget {
  const SubmitPage({Key? key, required this.padding}) : super(key: key);

  final double padding;

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  DateTime _lastPress =
      DateTime.fromMicrosecondsSinceEpoch(42); // haha 42 funny number

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (DateTime.now().millisecondsSinceEpoch -
                      _lastPress.millisecondsSinceEpoch >
                  1500) {
                _lastPress = DateTime.now();
                submitForm();
              }
            },
            child: const SizedBox(
              width: 70,
              height: 50,
              child: Center(
                child: Text(
                  'Submit',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> submitForm() async {
  List<InternetAddress> result = [];
  try {
    var timedOut = false;
    result = await InternetAddress.lookup("google.com").timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        timedOut = true;
        return [];
      },
    );
    if (timedOut) {
      return;
    }
  } on SocketException catch (_) {
    Fluttertoast.showToast(
        msg: "No internet connection", toastLength: Toast.LENGTH_LONG);
    return;
  }

  var cooldown = 5;
  if (DateTime.now().millisecondsSinceEpoch -
          ScouterStats.lastTimeSubmited.millisecondsSinceEpoch <
      cooldown * 1000) {
    var timeRemaining = (cooldown -
            ((DateTime.now().millisecondsSinceEpoch -
                    ScouterStats.lastTimeSubmited.millisecondsSinceEpoch) /
                1000))
        .toInt();
    Fluttertoast.showToast(msg: "Wait another $timeRemaining seconds");
    return;
  }

  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    var r = await Requests.get(
      'https://docs.google.com/forms/u/0/d/e/$formId/formResponse',
      queryParameters: {
        formParamaters[0]: AutonomousStats.blueCargoScored,
        formParamaters[1]: GameStats.blueCargoScored,
        formParamaters[2]: GameStats.redCargoScored,
      },
    );
    r.raiseForStatus();
    ScouterStats.lastTimeSubmited = DateTime.now();
    Fluttertoast.showToast(msg: "Submited response!");
  } else {
    Fluttertoast.showToast(
        msg: "No internet connection", toastLength: Toast.LENGTH_LONG);
  }
}
