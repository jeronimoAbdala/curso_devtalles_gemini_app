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
  Future<Map<String, dynamic>> getResponseFishingStream({
  required List<XFile> files,
}) async {
  // 1) Prompt base con ejemplo
  const basePrompt = '''
Describe el pez de la imagen. Te va a ingresar la imagen de un pez.
Necesito que devuelvas un JSON EXACTO como el siguiente (pon mucha énfasis en tamaño y peso; los datos que no sepas, déjalos en blanco):

{
  "nombreComun": "",
  "nombreCientifico": "",
  "tamanio-largo": "",
  "tamanio-ancho": "",
  "peso": "",
  "color": "",
  "especie": ""
}
''';

  const ejemplo = {
    "nombreComun": "Lubina rayada",
    "nombreCientifico": "Morone saxatilis",
    "tamanio-largo": "20cm",
    "tamanio-ancho": "8cm",
    "peso": "1 Kg",
    "color": "plateado con líneas azules",
    "especie": "Morone saxatilis"
  };
  final ejemploTexto = const JsonEncoder.withIndent('  ').convert(ejemplo);
  final prompt = '$basePrompt\nEjemplo de JSON:\n$ejemploTexto';

  // 2) Construyo el FormData
  final formData = FormData()..fields.add(MapEntry('prompt', prompt));
  for (final file in files) {
    final mimeStr = lookupMimeType(file.path) ?? 'application/octet-stream';
    final parts = mimeStr.split('/');
    final mp = await MultipartFile.fromFile(
      file.path,
      filename: file.name,
      contentType: MediaType(parts[0], parts[1]),
    );
    formData.files.add(MapEntry('files', mp));
  }

  try {
    // 3) Uso tu cliente `http` para hacer la llamada
    final response = await http.post(
      '/basic-prompt-stream-fishing',
      data: formData,
      options: Options(responseType: ResponseType.json),
    );

    // 4) Parseo la respuesta a Map<String, dynamic>
final raw = response.data;

// Si viene como String, quitamos cualquier texto antes/después del JSON
String jsonString;
if (raw is String) {
  final text = raw;
  final start = text.indexOf('{');
  final end   = text.lastIndexOf('}');
  if (start != -1 && end != -1 && end > start) {
    jsonString = text.substring(start, end + 1);
  } else {
    // No encontramos llaves: usamos todo como está
    jsonString = text;
  }
} else {
  // Si no es String, lo convertimos directamente a JSON
  jsonString = json.encode(raw);
}

// Ahora sí decodificamos
final Map<String, dynamic> decoded = json.decode(jsonString) as Map<String, dynamic>;

// 5) Devuelvo sólo los campos que me interesan
return {
  'nombreComun':      decoded['nombreComun']      ?? '',
  'nombreCientifico': decoded['nombreCientifico'] ?? '',
  'tamanio-largo':    decoded['tamanio-largo']    ?? '',
  'tamanio-ancho':    decoded['tamanio-ancho']    ?? '',
  'peso':             decoded['peso']             ?? '',
  'color':            decoded['color']            ?? '',
  'especie':          decoded['especie']          ?? '',
};

  } on DioError catch (e) {
    final msg = (e.response?.statusCode == 400)
        ? 'Petición mal formada'
        : e.message;
    throw Exception('Error al obtener respuesta de IA: $msg');
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
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