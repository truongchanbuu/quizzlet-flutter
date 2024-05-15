import 'package:quizzlet_fluttter/injection_container.dart';
import 'package:text_to_speech/text_to_speech.dart';

Future<bool?> pronounce(String text) async {
  var isPronouncing = sl.get<TextToSpeech>().speak(text);
  return isPronouncing;
}
