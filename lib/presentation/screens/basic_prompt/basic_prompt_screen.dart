import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/chat/basic_chat.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:gemini_app/presentation/widgets/chat/custom_bottom_chat_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


// final messages = <types.Message>[
//   types.TextMessage(author: user, id: Uuid().v4(), text: 'Mensaje1'),
//   types.TextMessage(author: user, id: Uuid().v4(), text: 'Mensaje2'),
//   types.TextMessage(author: user, id: Uuid().v4(), text: 'Mensaje3'),
//   types.TextMessage(author: geminiUser, id: Uuid().v4(), text: 'Respuesta Gemini'),
// ];


class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final geminiUser = ref.watch(geminiUserProvider);
    final user = ref.watch(userProvider);
    final isGeminiWriting = ref.watch(isGeminiWritingProvider);
    final chatMessages = ref.watch(basicChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Basico, sin historial'),

      ),
      body: Chat(
        //Usando el paquete Flutter_Chat
        //Primero seteeamos el mensaje
      messages: chatMessages, 

        //Declarando lo que pasa cuando hacemos enviar 
      onSendPressed: (types.PartialText partialText) {
          // final basicChatNotifier = ref.read(basicChatProvider.notifier);
          // basicChatNotifier.addMessage(partialText: partialText, user: user);
        },

        //Declaramos el usuario principal
      user: user,

      customBottomWidget: CustomBottomInput(onSend: (partialText, {images = const[]}) {
          final basicChatNotifier = ref.read(basicChatProvider.notifier);
          basicChatNotifier.addMessage(partialText: partialText, user: user, images: images);

          print(images);
      },),

        //Definimos el metodo para cargar archivos
      onAttachmentPressed: () async {
        ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage(limit : 4);
        if(images.isEmpty) return;
        print(images);
      },


        //Mostramos el is typing
       typingIndicatorOptions: TypingIndicatorOptions(
          typingUsers: isGeminiWriting ? [geminiUser] : [],
          customTypingWidget: const Center(
            child: Text('Gemini está pensando...'),
          ),),

      //Extras
      showUserAvatars: true,
      showUserNames: true,
       theme:DarkChatTheme(),)
    );
  }
}