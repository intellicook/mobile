import 'package:app_controller_client/app_controller_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_by_recipe.g.dart';

@riverpod
class ChatByRecipe extends _$ChatByRecipe {
  @override
  ChatByRecipeState build() {
    return ChatByRecipeState.init();
  }

  Future<String> sendMessage(String message, int recipeId) async {
    final client = ref.watch(appControllerProvider).client;
    final api = client.getRecipeSearchApi();
    final messages = state.messages;

    messages.add((ChatByRecipeMessageModelBuilder()
          ..role = ChatByRecipeRoleModel.user
          ..text = message)
        .build());

    state = ChatByRecipeState.success(messages);

    try {
      final requestBuilder = ChatByRecipePostRequestModelBuilder()
        ..id = recipeId
        ..messages = ListBuilder(messages);

      final response = await api.recipeSearchChatByRecipePost(
        chatByRecipePostRequestModel: requestBuilder.build(),
      );

      messages.add(response.data!.message);

      state = ChatByRecipeState.success(
        messages,
        functionCall: response.data!.functionCall,
      );

      return response.data!.message.text;
    } catch (e) {
      state = ChatByRecipeState.error(messages, e);
    }

    return 'An error occurred, I am sincerely sorry for not being able to '
        'process your request';
  }

  void addAssistantMessage(String message) {
    final messages = state.messages;

    messages.add((ChatByRecipeMessageModelBuilder()
          ..role = ChatByRecipeRoleModel.assistant
          ..text = message)
        .build());

    state = ChatByRecipeState.success(messages);
  }
}

class ChatByRecipeState {
  ChatByRecipeState.init()
      : messages = [
          (ChatByRecipeMessageModelBuilder()
                ..role = ChatByRecipeRoleModel.assistant
                ..text = 'Hello! I am IntelliCook AI, your cooking assistant. '
                    'How can I help you?')
              .build()
        ],
        functionCall = null;

  const ChatByRecipeState.success(this.messages, {this.functionCall});

  ChatByRecipeState.error(messages, error)
      : messages = [
          ...messages,
          (ChatByRecipeMessageModelBuilder()
                ..role = ChatByRecipeRoleModel.assistant
                ..text = '⚠️ An error occurred, I am sincerely sorry for not '
                    'being able to process your request: ${error.toString()}')
              .build()
        ],
        functionCall = null;

  final List<ChatByRecipeMessageModel> messages;
  final ChatByRecipePostResponseModelFunctionCall? functionCall;
}
