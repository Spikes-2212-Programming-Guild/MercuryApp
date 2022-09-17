import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:toggle_switch/toggle_switch.dart';

const spikesBlue = Color.fromARGB(255, 46, 51, 136);
const bodyText = TextStyle(fontSize: 16);
const titleText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

abstract class ScouterStats {
  static String name = "";
  static int team = 0;
  static bool isBlueAlliance = false;
}

abstract class GameStats {
  static int blueCargoScored = 0;
}

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Tab> _tabs = const [
    Tab(text: "Info"),
    Tab(text: "Autonomous"),
    Tab(text: "Data")
  ];

  @override
  Widget build(BuildContext context) {
    InfoPage infoPage = const InfoPage();

    return MaterialApp(
      home: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("DCMP"),
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
            ],
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
            onChanged: (value) => ScouterStats.team = int.parse(value),
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
  int redCargoScored = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: SpinBox(
        min: 0,
        decoration: const InputDecoration(labelText: "Red Cargo Scored"),
        value: redCargoScored.toDouble(),
        onChanged: (value) => setState(
          () => redCargoScored = value.toInt(),
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
            value: 0,
          ),
        ],
      ),
    );
  }
}
