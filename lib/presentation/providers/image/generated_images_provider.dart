import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gemini_app/presentation/providers/image/generated_history_provider.dart';
import 'package:gemini_app/presentation/providers/image/is_generating_provider.dart';

part 'generated_images_provider.g.dart';

@Riverpod(keepAlive: true)
class GeneratedImages extends _$GeneratedImages {
  final GeminiImpl gemini = GeminiImpl();

  late final IsGenerating isGeneratingNotifier;
  late final GeneratedHistory generatedHistoryNotifier;

  String previousPrompt = '';
  List<XFile> previousImages = [];

// -> devuelve una lista de St
  @override
  List<String> build() {
    isGeneratingNotifier = ref.read(isGeneratingProvider.notifier);
    generatedHistoryNotifier = ref.read(generatedHistoryProvider.notifier);

    return [];
  }

  void addImage(String imageUrl) {
    if (imageUrl == '') return;
    generatedHistoryNotifier.addImage(imageUrl);
    state = [...state, imageUrl];
  }

  void clearImages() {
    state = [];
  }

  Future<void> generateImage(
    String prompt, {
    List<XFile> images = const [],
  }) async {
    isGeneratingNotifier.setIsGenerating();

   final imageUrl = await gemini.generateImage(prompt, files: images);

    if (imageUrl == null) {
      isGeneratingNotifier.setIsNotGenerating();
      return;
    }


    previousPrompt = prompt;
    previousImages = images;

    addImage(imageUrl);
    isGeneratingNotifier.setIsNotGenerating();

    if (state.length == 1) {
      generateImageWithPreviousPrompt();
    }
  }


  Future<void> generateImageWithPreviousPrompt() async {
    if (previousPrompt.isEmpty) return;

    print('prompt' + previousPrompt);


    await generateImage(previousPrompt, images: previousImages);
  }
}
