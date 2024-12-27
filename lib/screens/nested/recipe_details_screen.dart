import 'package:app_controller_client/app_controller_client.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/opacity.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/chat_by_recipe.dart';
import 'package:intellicook_mobile/widgets/high_level/background_scaffold.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/label_button.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/panel_card.dart';
import 'package:intellicook_mobile/widgets/low_level/clickable.dart';
import 'package:intellicook_mobile/widgets/low_level/glassmorphism.dart';

class RecipeDetailsScreen extends ConsumerStatefulWidget {
  const RecipeDetailsScreen({super.key, required this.recipe});

  final SearchRecipesRecipeModel recipe;

  @override
  ConsumerState<RecipeDetailsScreen> createState() =>
      _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends ConsumerState<RecipeDetailsScreen> {
  final chatController = TextEditingController();
  final chatFocusNode = FocusNode();

  @override
  void dispose() {
    chatController.dispose();
    chatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(chatByRecipeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
                            widget.recipe.name,
                            style: textTheme.titleLarge,
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
                                .map(
                                  (ingredient) => DecoratedBox(
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
                                        ingredient,
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
                          ...widget.recipe.detail!.instructions
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
            onClicked: onChatClicked,
          ),
        ],
      ),
    );
  }

  Widget buildChat(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final chatByRecipe = ref.watch(chatByRecipeProvider);

        final theme = Theme.of(context);

        void onChatSubmitted() async {
          if (chatByRecipe.messages.last.role == ChatByRecipeRoleModel.user) {
            return;
          }

          final value = chatController.text.trim();
          if (value.isEmpty) return;

          chatController.clear();
          chatFocusNode.requestFocus();

          await ref
              .read(chatByRecipeProvider.notifier)
              .sendMessage(value, widget.recipe.id);
        }

        return Padding(
          padding: const EdgeInsets.only(top: SpacingConsts.m),
          child: Panel(
            borderRadius: const SmoothBorderRadius.only(
              topLeft: SmoothRadius(
                  cornerRadius: SmoothBorderRadiusConsts.lCornerRadius,
                  cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing),
              topRight: SmoothRadius(
                  cornerRadius: SmoothBorderRadiusConsts.lCornerRadius,
                  cornerSmoothing: SmoothBorderRadiusConsts.cornerSmoothing),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: SpacingConsts.xs,
                                  ),
                                  child: CircleAvatar(
                                    radius: SpacingConsts.m,
                                    backgroundImage: Image.asset(
                                      'assets/icons/default.png',
                                    ).image,
                                  ),
                                ),
                              const SizedBox(width: SpacingConsts.s),
                              Flexible(
                                child: PanelCard.low(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(SpacingConsts.s),
                                    child: Text(
                                      message.text,
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
                                      'assets/profile/profile_picture.jpg',
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
                    suffix: Clickable(
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
}
