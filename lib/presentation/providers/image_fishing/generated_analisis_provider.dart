import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/screens/fishingCalculator/fishing_calculator_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated_analisis_provider.g.dart';
@riverpod
class GeneratedAnalisisProvider extends _$GeneratedAnalisisProvider {

  final gemini = GeminiImpl();

  @override
   build() {
    return [];
  }

  Future<void> sendPrompt({
    required String prompt ,
    List<XFile> images = const [],
  }) async {
  final textResponse = await gemini.getResponseFishingStream(  files: images);
            
  }

  Future<void> generateCaption(int index, XFile pair) async {
  try {
    // 1) Llamo a tu nuevo método que usa `http` y parsea el JSON
    final data = await gemini.getResponseFishingStream(files: [pair]);

    // 2) Creo el AnalysisResult a partir del Map devuelto
    final analysis = AnalysisResult(
      size: '${data['tamanio-largo']} × ${data['tamanio-ancho']}',
      weight: data['peso']!,
      color: data['color']!,
      species: data['especie']!,
    );

    // 3) Actualizo el estado con el resultado
    ref
      .read(galleryImagesProvider.notifier)
      .updateAnalysis(index, analysis);

  } catch (e) {
    // Aquí puedes mostrar un SnackBar o similar
    print('Error generando análisis: $e');
  }
}


  
}

class ImageWithCaption {
  final XFile file;
  String caption;
  AnalysisResult? analysis;    // ← nuevo

  ImageWithCaption({required this.file, this.caption = '', this.analysis});
}


class AnalysisResult {
  final String size;
  final String weight;
  final String color;
  final String species; 

  AnalysisResult({
    required this.size,
    required this.weight,
    required this.color,
    required this.species,
  });
}
