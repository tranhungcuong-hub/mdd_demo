import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mdd_demo/api/sentence_api.dart';
import 'package:mdd_demo/record.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showPlayer = false;
  String? audioPath;
  late AudioPlayer audioPlayer;
  bool isLoading = false;
  Map<String, dynamic> data = {};
  final Random _random = Random();

  int generateRandomNumber() {
    return _random.nextInt(99 - 0);
  }

  void fetchEngSentence() async {
    setState(() {
      isLoading = true;
    });
    data = await fetchSentences();
    setState(() {
      isLoading = false;
    });
    print(data['results'][0]['lexicalEntries'][0]['sentences'].length);
  }

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    showPlayer = false;
    fetchEngSentence();
    super.initState();
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath!);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              fetchEngSentence(); // Call the fetchEngSentence function to refresh data
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading == false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: SizedBox(
                    width: 380,
                    child: Center(
                      child: Text(
                        data['results'][0]['lexicalEntries'][0]['sentences']
                                [generateRandomNumber()]['text']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                AudioRecorder(
                  onStop: (String path) {
                    if (kDebugMode) print('Recorded file path: $path');
                    audioPath = path;
                    showPlayer = true;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.3),
                  ),
                  child: OutlinedButton(
                    onPressed: playRecording,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    child: const Text(
                      "Check result",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
