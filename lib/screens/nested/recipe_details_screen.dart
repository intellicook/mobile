import 'package:app_controller_client/app_controller_client.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/chat_by_recipe.dart';
import 'package:intellicook_mobile/providers/app_controller/set_user_profile.dart';
import 'package:intellicook_mobile/screens/nested/recipe_search_screen.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/panel_card.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:intellicook_mobile/widgets/low_level/glassmorphism.dart';
import 'package:speech_to_text/speech_to_text.dart';

class RecipeDetailsScreen extends ConsumerStatefulWidget {
  const RecipeDetailsScreen({super.key, required this.recipe});

  final SearchRecipesRecipeModel recipe;

  @override
  ConsumerState<RecipeDetailsScreen> createState() =>
      _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends ConsumerState<RecipeDetailsScreen>
    with WidgetsBindingObserver {
  final chatController = TextEditingController();
  final chatFocusNode = FocusNode();
  final flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  final speechPartialText = ValueNotifier<String>('');
  final speechEntireText = ValueNotifier<String>('');
  final speechAvailable = ValueNotifier<bool>(false);
  final speechEnabled = ValueNotifier<bool>(false);

  Future<void> sendChatMessage() async {
    debugPrint('Sending chat message: ${chatController.text}');

    final value = chatController.text.trim();
    if (value.isEmpty) return;

    chatController.clear();
    chatFocusNode.requestFocus();

    final response = await ref
        .read(chatByRecipeProvider.notifier)
        .sendMessage(value, widget.recipe.id);

    if (response.isNotEmpty) {
      await flutterTts.speak(response);
    }
  }

  @override
  void initState() {
    Future<void> initTts() async {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
    }

    Future<void> initSpeech() async {
      final available = await speechToText.initialize(
        onStatus: (status) async {
          if (!speechEnabled.value || !mounted) {
            return;
          }

          if (status == 'notListening' || status == 'done') {
            await startSpeechToText();
          }
        },
      );
      speechAvailable.value = available;
    }

    super.initState();
    initTts();
    initSpeech();
  }

  Future<void> startSpeechToText() async {
    if (speechToText.isListening) {
      return;
    }

    if (speechAvailable.value) {
      await speechToText.listen(
        onResult: (result) async {
          if (!speechEnabled.value || !mounted) {
            return;
          }

          flutterTts.stop();
          chatController.text = result.recognizedWords;
          if (result.finalResult &&
              chatController.text.isNotEmpty &&
              ref.read(chatByRecipeProvider).messages.last.role ==
                  ChatByRecipeRoleModel.assistant) {
            await sendChatMessage();
          }
        },
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 2),
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          autoPunctuation: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    chatController.dispose();
    chatFocusNode.dispose();
    flutterTts.stop();
    speechToText.stop();
    speechEntireText.dispose();
    speechPartialText.dispose();
    speechAvailable.dispose();
    speechEnabled.dispose();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    flutterTts.stop();
    speechToText.stop();
    return super.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(chatByRecipeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final matchedIngredientIndices = widget.recipe.matches
        .where(
            (match) => match.field == SearchRecipesMatchFieldModel.ingredients)
        .map((match) => match.index!)
        .toSet();

    void onChatClicked() {
      FocusManager.instance.primaryFocus?.unfocus();
      showModalBottomSheet(
        context: context,
        builder: buildChat,
        isScrollControlled: true,
        useSafeArea: true,
        clipBehavior: Clip.antiAlias,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      );
    }

    return BackgroundScaffold(
      title: 'Recipe Details',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Panel(
              padding: EdgeInsets.zero,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(SpacingConsts.m),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipe.title,
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          Text(
                            widget.recipe.description,
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: SpacingConsts.m),
                          Text(
                            'Nutrition Values',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          Row(
                            children: [
                              Text('Calories: ', style: textTheme.bodyMedium),
                              buildNutritionValue(
                                context,
                                widget.recipe.detail!.nutrition.calories,
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingConsts.xs),
                          Row(
                            children: [
                              Text('Protein: ', style: textTheme.bodyMedium),
                              buildNutritionValue(
                                context,
                                widget.recipe.detail!.nutrition.protein,
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingConsts.xs),
                          Row(
                            children: [
                              Text('Fat: ', style: textTheme.bodyMedium),
                              buildNutritionValue(
                                context,
                                widget.recipe.detail!.nutrition.fat,
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingConsts.xs),
                          Row(
                            children: [
                              Text('Carbs: ', style: textTheme.bodyMedium),
                              buildNutritionValue(
                                context,
                                widget.recipe.detail!.nutrition.carbs,
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingConsts.m),
                          Text(
                            'Ingredients',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          Wrap(
                            spacing: SpacingConsts.s,
                            runSpacing: SpacingConsts.s,
                            children: widget.recipe.ingredients
                                .asMap()
                                .entries
                                .map(
                                  (entry) => DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: SmoothBorderRadiusConsts
                                            .sCornerRadius,
                                        cornerSmoothing:
                                            SmoothBorderRadiusConsts
                                                .cornerSmoothing,
                                      ),
                                      border: Border.all(
                                        width: 1.5,
                                        color: colorScheme.outline,
                                      ),
                                      color: colorScheme.surfaceContainerLow
                                          .withOpacity(
                                              OpacityConsts.low(context)),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(SpacingConsts.s),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (matchedIngredientIndices
                                              .contains(entry.key))
                                            Icon(
                                              Icons.check_circle_outline,
                                              color:
                                                  textTheme.bodyMedium?.color,
                                              size: SpacingConsts.m,
                                            ),
                                          const SizedBox(
                                            width: SpacingConsts.xs,
                                          ),
                                          Flexible(
                                            child: Text(
                                              '${entry.value.name}'
                                              '${entry.value.quantity == null && entry.value.unit == null ? '' : ': '}'
                                              '${entry.value.quantity}'
                                              ' ${entry.value.unit}',
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: SpacingConsts.m),
                          Text(
                            'Utensils',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          Wrap(
                            spacing: SpacingConsts.s,
                            runSpacing: SpacingConsts.s,
                            children: widget.recipe.detail!.utensils
                                .map(
                                  (utensil) => DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: SmoothBorderRadiusConsts
                                            .sCornerRadius,
                                        cornerSmoothing:
                                            SmoothBorderRadiusConsts
                                                .cornerSmoothing,
                                      ),
                                      border: Border.all(
                                        width: 1.5,
                                        color: colorScheme.outline,
                                      ),
                                      color: colorScheme.surfaceContainerLow
                                          .withOpacity(
                                              OpacityConsts.low(context)),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(SpacingConsts.s),
                                      child: Text(
                                        utensil,
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: SpacingConsts.m),
                          Text(
                            'Instructions',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          ...widget.recipe.detail!.directions
                              .where((value) => value.isNotEmpty)
                              .toList()
                              .asMap()
                              .entries
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: SpacingConsts.s,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Step ${entry.key + 1}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: SpacingConsts.s),
                                      Text(entry.value),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingConsts.m),
          LabelButton(
            label: 'Chat with IntelliCook for more...',
            isHigh: true,
            onClicked: onChatClicked,
          ),
        ],
      ),
    );
  }

  Widget buildNutritionValue(
    BuildContext context,
    RecipeNutritionValueModel nutritionValue,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: SmoothBorderRadius(
          cornerRadius: SmoothBorderRadiusConsts.sCornerRadius,
          cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing,
        ),
        border: Border.all(
          width: 1.5,
          color: colorScheme.outline,
        ),
        color: colorScheme.surfaceContainerLow
            .withOpacity(OpacityConsts.low(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingConsts.s,
          vertical: SpacingConsts.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nutritionValue.name,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(
              width: SpacingConsts.xs,
            ),
            Icon(
              switch (nutritionValue) {
                RecipeNutritionValueModel.none => Icons.exposure_zero,
                RecipeNutritionValueModel.low => Icons.keyboard_arrow_down,
                RecipeNutritionValueModel.medium => Icons.remove,
                RecipeNutritionValueModel.high => Icons.keyboard_arrow_up,
                _ => Icons.error_outlined,
              },
              color: textTheme.bodyMedium?.color,
              size: SpacingConsts.ms,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChat(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final chatByRecipe = ref.watch(chatByRecipeProvider);

        final theme = Theme.of(context);

        void onChatSubmitted() {
          if (chatByRecipe.messages.last.role == ChatByRecipeRoleModel.user) {
            return;
          }

          sendChatMessage();
        }

        void onSpeechToggled() async {
          speechEnabled.value = !speechEnabled.value;

          if (speechEnabled.value) {
            startSpeechToText();
          }
        }

        return Padding(
          padding: const EdgeInsets.only(top: SpacingConsts.m),
          child: Panel(
            borderRadius: const SmoothBorderRadius.only(
              topLeft: SmoothRadius(
                cornerRadius: SmoothBorderRadiusConsts.lCornerRadius,
                cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing,
              ),
              topRight: SmoothRadius(
                cornerRadius: SmoothBorderRadiusConsts.lCornerRadius,
                cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing,
              ),
            ),
            child: Glassmorphism(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: SpacingConsts.m),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: SpacingConsts.s,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius:
                                SmoothBorderRadiusConsts.sCornerRadius,
                            cornerSmoothing:
                                SmoothBorderRadiusConsts.cornerSmoothing,
                          ),
                          color:
                              theme.textTheme.bodyMedium?.color ?? Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      padding:
                          const EdgeInsets.symmetric(vertical: SpacingConsts.m),
                      itemCount: chatByRecipe.messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            chatByRecipe.messages.reversed.toList()[index];
                        final isUserMessage =
                            message.role == ChatByRecipeRoleModel.user;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: SpacingConsts.xs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: isUserMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isUserMessage)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SpacingConsts.xs,
                                  ),
                                  child: CircleAvatar(
                                    radius: SpacingConsts.m,
                                    backgroundImage: AssetImage(
                                      'assets/default_chat_icon.png',
                                    ),
                                  ),
                                ),
                              const SizedBox(width: SpacingConsts.s),
                              Flexible(
                                child: PanelCard.low(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(SpacingConsts.s),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.text,
                                        ),
                                        if (index == 0 &&
                                            chatByRecipe.functionCall !=
                                                null) ...[
                                          const SizedBox(
                                            height: SpacingConsts.s,
                                          ),
                                          buildFunctionCall(
                                            context,
                                            chatByRecipe.functionCall!,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: SpacingConsts.s),
                              if (isUserMessage)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SpacingConsts.xs,
                                  ),
                                  child: CircleAvatar(
                                    radius: SpacingConsts.m,
                                    backgroundImage: AssetImage(
                                      'assets/default_chat_icon.png',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  InputField(
                    controller: chatController,
                    focusNode: chatFocusNode,
                    autofocus: true,
                    maxLines: null,
                    hint: 'Ask for tips or interesting facts...',
                    suffix: Padding(
                      padding: const EdgeInsets.all(SpacingConsts.s),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: speechAvailable,
                            builder: (context, speechAvailable, _) {
                              if (!speechAvailable) {
                                return const SizedBox.shrink();
                              }

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Clickable(
                                    onClicked: onSpeechToggled,
                                    child: ValueListenableBuilder(
                                      valueListenable: speechEnabled,
                                      builder: (context, speechEnabled, _) {
                                        return Icon(
                                          speechEnabled
                                              ? Icons.mic
                                              : Icons.mic_off,
                                          size: SpacingConsts.ml,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: SpacingConsts.s),
                                ],
                              );
                            },
                          ),
                          Clickable(
                            onClicked: onChatSubmitted,
                            child: Icon(
                              Icons.send_rounded,
                              size: SpacingConsts.ml,
                              color: chatByRecipe.messages.last.role ==
                                      ChatByRecipeRoleModel.user
                                  ? theme.disabledColor
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFunctionCall(
    BuildContext context,
    ChatByRecipePostResponseModelFunctionCall functionCall,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (functionCall.oneOf.value is SetUserProfilePostRequestModel) {
      ref.listen(
        setUserProfileProvider,
        handleErrorAsSnackBar(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: switch (functionCall.oneOf.value) {
        SetUserProfilePostRequestModel setUserProfile => [
            Text(
              'Action: update dietary preferences',
              style: textTheme.bodyMedium,
            ),
            Text(
              'Diet type: ${setUserProfile.veggieIdentity.name}',
              style: textTheme.bodyMedium,
            ),
            Text(
              'Preferred foods:',
              style: textTheme.bodyMedium,
            ),
            ...setUserProfile.prefer.map(
              (food) => Text(
                '• $food',
                style: textTheme.bodyMedium,
              ),
            ),
            Text(
              'Disliked foods:',
              style: textTheme.bodyMedium,
            ),
            ...setUserProfile.dislike.map(
              (food) => Text(
                '• $food',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: SpacingConsts.m),
            LabelButton(
              label: 'Update Profile',
              onClicked: () {
                ref.read(setUserProfileProvider.notifier).post(
                      setUserProfile.veggieIdentity,
                      setUserProfile.prefer,
                      setUserProfile.dislike,
                    );
                ref.read(chatByRecipeProvider.notifier).addAssistantMessage(
                      'User profile updated successfully!',
                    );
              },
            ),
          ],
        SearchRecipesPostRequestModel searchRecipes => [
            Text(
              'Action: search recipes',
              style: textTheme.bodyMedium,
            ),
            Text(
              'Ingredients:',
              style: textTheme.bodyMedium,
            ),
            ...searchRecipes.ingredients.map(
              (ingredient) => Text(
                '• $ingredient',
                style: textTheme.bodyMedium,
              ),
            ),
            Text(
              'Extra terms: ${searchRecipes.extraTerms}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: SpacingConsts.m),
            LabelButton(
              label: 'Search Recipes',
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: RecipeSearchScreen(
                      ingredients: searchRecipes.ingredients.toList(),
                      extraTerms: searchRecipes.extraTerms,
                    ),
                  ),
                ));
              },
            ),
          ],
        _ => const [],
      },
    );
  }
}
