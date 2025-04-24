import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/chat/basic_chat.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
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
        title: const Text('data'),

      ),
      body: Chat(
        //Usando el paquete Flutter_Chat
        //Primero seteeamos el mensaje
      messages: chatMessages, 

        //Declarando lo que pasa cuando hacemos enviar 
      onSendPressed: (types.PartialText partialText) {
          final basicChatNotifier = ref.read(basicChatProvider.notifier);
          basicChatNotifier.addMessage(partialText: partialText, user: user);
        },

        //Declaramos el usuario principal
      user: user,


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