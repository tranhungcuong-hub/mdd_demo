import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mdd_demo/api/sentence_api.dart';
import 'package:mdd_demo/record.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showPlayer = false;
  String? audioPath;
  late AudioPlayer audioPlayer;
  bool isLoading = false;
  Map<String, dynamic> data = {};

  void fetchEngSentence() async {
    setState(() {
      isLoading = true;
    });
    data = await fetchSentences();
    setState(() {
      isLoading = false;
    });
    // print(data['results'][0]['lexicalEntries'][0]['sentences'].length);
  }

  Future<void> getModelResult(String audioPath) async {
    try {
      if (audioPath.isNotEmpty) {
        print('abc');
        final response = await http.post(Uri.parse('http://127.0.0.1:5000/'),
            body: {'audio_path': audioPath});
      }
    } catch (e) {
      print(e);
    }
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
      await getModelResult(audioPath!);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 250, left: 20, right: 20),
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Center(
                          child: Text(
                            'jhgjh'.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.clip,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AudioRecorder(
                    onStop: (String path) async {
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
              ),
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
