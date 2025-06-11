import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class GeminiImpl {
  final Dio http = Dio(
    BaseOptions(
      baseUrl: dotenv.env['ENDPOINT_API'] ?? '')
  );


  Future<String> getResponse(String prompt) async {
    try {
      final body = { 'prompt' : prompt};
      final response = await http.post('/basic-prompt', data: jsonEncode(body));
      return response.data;
    } catch (e) {
      print(e);
      throw Exception("Cant get gemini response");

    }
      
  }

  Future<String> getResponseStream(
  String prompt, {
  List<XFile> files = const [],
}) async {
  // 1. Preparo el FormData con prompt + archivos
   final formData = FormData()..fields.add(MapEntry('prompt', prompt));

  for (final file in files) {
    // 1) averiguo mimeType, p.e. "image/jpeg"
    final mimeStr = lookupMimeType(file.path) ?? 'application/octet-stream';
    final parts = mimeStr.split('/');
    // 2) preparo el MultipartFile con contentType
    final mp = await MultipartFile.fromFile(
      file.path,
      filename: file.name,
      contentType: MediaType(parts[0], parts[1]),
    );
    formData.files.add(MapEntry('files', mp));
  }

  try {
    // 2. Hago la petición normal (json), sin stream
    final response = await http.post(
      '/basic-prompt-stream',
      data: formData,
      options: Options(responseType: ResponseType.json),
    );

    // 3. Devuelvo el body como String
    //    Si tu API regresa JSON, podés hacer:
    //    return response.data['result'] as String;
    return response.data.toString();
  } on DioError catch (dioErr) {
    // 4. Manejo de errores específico de Dio
    final msg = dioErr.response?.statusCode == 400
        ? 'Petición mal formada'
        : dioErr.message;
    throw Exception('Error al obtener respuesta: $msg');
  } catch (e) {
    // 5. Otros errores
    throw Exception('Error inesperado: $e');
  }



      // final stream = response.data.stream as Stream<List<int>>;
      // String buffer = '';

      // await for ( final chunk in stream ){
        
      //   final chunkString = utf8.decode(chunk, allowMalformed: true);
      //   buffer += chunkString;
      //   yield buffer;

      // }
  }


  Stream<String> getChatStream(String prompt, String chatId, { List<XFile> files = const[]}) async* {

    final formData = FormData();
    formData.fields.add(MapEntry('prompt', prompt));
    formData.fields.add(MapEntry('chatId', chatId));

    if (files.isNotEmpty){
      for(final file in files.reversed){
        formData.files.add(MapEntry('files', await MultipartFile.fromFile(
          file.path, filename: file.name
        )));
      }
    }

    final body = { 'prompt' : prompt};
      final response = await http.post('/chat-stream', data: formData, options: Options(
        responseType: ResponseType.stream
      ));


      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';

      await for ( final chunk in stream ){
        
        final chunkString = utf8.decode(chunk, allowMalformed: true);
        buffer += chunkString;
        yield buffer;

      }
  }


   Future<String?> generateImage(
    String prompt, {
    List<XFile> files = const [],
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('prompt', prompt));

    for (final file in files) {
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(file.path, filename: file.name),
        ),
      );
    }

    try {
      final response = await http.post('/image-generation', data: formData);
      final imageUrl = 'http://192.168.0.229:3000/api/gemini/ai-images/' +  response.data['imageUrl'];
    

      if (imageUrl == '') {
        return null;
      }

      return imageUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

Future<String?> getImage(String imageName) async {
  // 1) Armo la ruta relativa al endpoint
  final relativePath = '/ai-images/$imageName';

  try {
    // 2) Hago un GET para ver si existe (no me interesa el body, 
    //    solo el statusCode)
    final response = await http.get(
      relativePath,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      // 3) Si existe, retorno la URL completa (baseUrl + relativePath)
      return http.options.baseUrl + relativePath;
    } else {
      // 4) Si no es 200 (por ejemplo 404), devuelvo null
      return null;
    }
  } catch (e) {
    // Error de red, servidor caído, CORS, etc.
    print('Error en getImage(): $e');
    return null;
  }
}

}