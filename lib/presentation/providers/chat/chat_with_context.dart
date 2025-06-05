import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:gemini_app/config/gemini/gemini_impl.dart';



// -> declaramos riverpod y sincronizamos el archivo.g con el comando que esta en readme.md
part 'chat_with_context.g.dart';
final uuid = Uuid();
@Riverpod(keepAlive: true)
class ChatWithContext extends _$ChatWithContext {

  // -> importamos la impl de gemini (conexion con el endpoint)
  final gemini = GeminiImpl();

  late User geminiUser;
  late String chatId;

  // ->  despues del override, decimos que tipo de dato va a devolver este metodo.
  //      En este caso: un listao de mensajes.
  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    chatId = uuid.v4();
    return [];
  }

// -----------------------------------------------------------------
// Ahora declaramos las funciones que vamos a poder usar
// -----------------------------------------------------------------
  void addMessage({
    required PartialText partialText,
    required User user,
    List<XFile> images = const [],
  }) {
    if (images.isNotEmpty) {
      _addTextMessageWithImages(partialText, user, images);
      return;
    }

    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _createTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text);
  }

  void _addTextMessageWithImages(
    PartialText partialText,
    User author,
    List<XFile> images,
  ) async {
    for (XFile image in images) {
      _createImageMessage(image, author);
    }

    await Future.delayed(Duration(milliseconds: 10));

    _createTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text, images: images);
  }

  void _geminiTextResponseStream(
    String prompt, {
    List<XFile> images = const [],
  }) async {
    _createTextMessage('Gemini está pensando...', geminiUser);

    gemini.getChatStream(prompt, chatId, files: images).listen((responseChunk) {
      if (responseChunk.isEmpty) return;

      final updatedMessages = [...state];
      final updatedMessage = (updatedMessages.first as TextMessage).copyWith(
        text: responseChunk,
      );

      updatedMessages[0] = updatedMessage;
      state = updatedMessages;
    });
  }

// -----------------------------------------------------------------
// Funciones Helpers
// -----------------------------------------------------------------
  void newChat() {
    chatId = uuid.v4();
    state = [];
  }

  void loadPreviousMessages(String chatId) {
    //todo:
  }

  void _createTextMessage(String text, User author) {
    final message = TextMessage(
      id: uuid.v4(),
      author: author,
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    state = [message, ...state];
  }

  Future<void> _createImageMessage(XFile image, User author) async {
    final message = ImageMessage(
      id: uuid.v4(),
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      uri: image.path,
      name: image.name,
      size: await image.length(),
    );

    state = [message, ...state];
  }
}
