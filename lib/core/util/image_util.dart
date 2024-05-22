import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzlet_fluttter/injection_container.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

var storage = sl.get<FirebaseStorage>();

Future<String?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  return image?.path;
}

String convertNativeUint8ListToImageUrl(Uint8List nativeUint8List) {
  String imageType = lookupMimeType('', headerBytes: nativeUint8List) ?? 'jpeg';

  String base64String = base64Encode(nativeUint8List);
  String imageUrl = 'data:image/$imageType;base64,$base64String';
  return imageUrl;
}

Future<File> createTempImageFile(String fileName, Uint8List bytes) async {
  final directory = await getDownloadsDirectory();
  final file = File('${directory?.path}/$fileName');

  await file.writeAsBytes(bytes);

  return file;
}

@override
Future<String> uploadIllustrator(
    String topicId, String wordId, String filePath) async {
  Reference refRoot = storage.ref();
  Reference refIllustrators = refRoot.child('/illustrators');

  try {
    Reference refUploadFile = refIllustrators.child(topicId);

    await refUploadFile.putFile(File(filePath));
    String illustratorUrl = await refUploadFile.getDownloadURL();

    return illustratorUrl;
  } on FirebaseException catch (e) {
    print(e.message);
    return e.message ?? 'There is something wrong';
  }
}
