import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
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
  final textResponse = await gemini.getResponseStream( prompt, files: images);
            

  }
}