import 'package:app_controller_client/app_controller_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellicook_mobile/constants/spacing.dart';
import 'package:intellicook_mobile/providers/app_controller/set_user_profile.dart';
import 'package:intellicook_mobile/providers/app_controller/user_profile.dart';
import 'package:intellicook_mobile/utils/handle_error_as_snack_bar.dart';
import 'package:intellicook_mobile/widgets/high_level/dropdown.dart';
import 'package:intellicook_mobile/widgets/high_level/input_field.dart';
import 'package:intellicook_mobile/widgets/high_level/panel.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer.dart';

class ProfileDietaryPreferencesPanel extends ConsumerStatefulWidget {
  const ProfileDietaryPreferencesPanel({super.key});

  @override
  ConsumerState createState() => _ProfileDietaryPreferencesPanelState();
}

class _ProfileDietaryPreferencesPanelState
    extends ConsumerState<ProfileDietaryPreferencesPanel> {
  final _preferredFoodController = TextEditingController();
  final _dislikedFoodController = TextEditingController();

  List<String> _preferredFoods = [];
  List<String> _dislikedFoods = [];
  UserProfileVeggieIdentityModel _veggieIdentity =
      UserProfileVeggieIdentityModel.none;

  @override
  void dispose() {
    _preferredFoodController.dispose();
    _dislikedFoodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final setUserProfile = ref.watch(setUserProfileProvider);

    ref.listen(
      userProfileProvider,
      handleErrorAsSnackBar(context),
    );

    ref.listen(
      setUserProfileProvider,
      handleErrorAsSnackBar(context),
    );

    void savePreferences() {
      ref.read(setUserProfileProvider.notifier).post(
            _veggieIdentity,
            _preferredFoods,
            _dislikedFoods,
          );
    }

    void addPreferredFood() {
      final food = _preferredFoodController.text.trim();
      if (food.isNotEmpty) {
        setState(() {
          _preferredFoods.add(food);
          _preferredFoodController.clear();
        });
        savePreferences();
      }
    }

    void addDislikedFood() {
      final food = _dislikedFoodController.text.trim();
      if (food.isNotEmpty) {
        setState(() {
          _dislikedFoods.add(food);
          _dislikedFoodController.clear();
        });
        savePreferences();
      }
    }

    void removePreferredFood(int index) {
      setState(() {
        _preferredFoods.removeAt(index);
      });
      savePreferences();
    }

    void removeDislikedFood(int index) {
      setState(() {
        _dislikedFoods.removeAt(index);
      });
      savePreferences();
    }

    // Initialize with data when available
    if (userProfile is AsyncData && userProfile.value != null) {
      // Only update once to avoid overriding user edits
      if (_preferredFoods.isEmpty && _dislikedFoods.isEmpty) {
        _preferredFoods = userProfile.value!.prefer.toList();
        _dislikedFoods = userProfile.value!.dislike.toList();
        _veggieIdentity = userProfile.value!.veggieIdentity;
      }
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Create veggie identity dropdown entries
    final veggieIdentityEntries = [
      const DropdownEntry<UserProfileVeggieIdentityModel>(
        value: UserProfileVeggieIdentityModel.none,
        label: 'Omnivore',
      ),
      const DropdownEntry<UserProfileVeggieIdentityModel>(
        value: UserProfileVeggieIdentityModel.vegetarian,
        label: 'Vegetarian',
      ),
      const DropdownEntry<UserProfileVeggieIdentityModel>(
        value: UserProfileVeggieIdentityModel.vegan,
        label: 'Vegan',
      ),
    ];

    return Panel(
      child: switch (userProfile) {
        AsyncData() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dietary Preferences',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: SpacingConsts.m),
              Dropdown<UserProfileVeggieIdentityModel>(
                label: 'Diet Type',
                initialValue: _veggieIdentity,
                entries: veggieIdentityEntries,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _veggieIdentity = value;
                    });
                    savePreferences();
                  }
                },
              ),
              const SizedBox(height: SpacingConsts.m),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferred Foods',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: SpacingConsts.s),
                        ..._preferredFoods.asMap().entries.map((entry) {
                          final index = entry.key;
                          final food = entry.value;

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: SpacingConsts.xs),
                            child: InputField(
                              readOnly: true,
                              controller: TextEditingController(text: food),
                              suffix: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => removePreferredFood(index),
                              ),
                            ),
                          );
                        }),
                        if (_preferredFoods.isNotEmpty)
                          const SizedBox(height: SpacingConsts.s),
                        InputField(
                          controller: _preferredFoodController,
                          hint: 'Add food item',
                          onSubmitted: (_) => addPreferredFood(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: SpacingConsts.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disliked Foods',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: SpacingConsts.s),
                        ..._dislikedFoods.asMap().entries.map((entry) {
                          final index = entry.key;
                          final food = entry.value;

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: SpacingConsts.xs),
                            child: InputField(
                              readOnly: true,
                              controller: TextEditingController(text: food),
                              suffix: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => removeDislikedFood(index),
                              ),
                            ),
                          );
                        }),
                        if (_dislikedFoods.isNotEmpty)
                          const SizedBox(height: SpacingConsts.s),
                        InputField(
                          controller: _dislikedFoodController,
                          hint: 'Add food item',
                          onSubmitted: (_) => addDislikedFood(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (setUserProfile is AsyncLoading) ...[
                const SizedBox(height: SpacingConsts.s),
                Text(
                  'saving...',
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        _ => Shimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dietary Preferences',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: SpacingConsts.m),
                Dropdown<UserProfileVeggieIdentityModel>(
                  label: 'Diet Type',
                  initialValue: _veggieIdentity,
                  entries: veggieIdentityEntries,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _veggieIdentity = value;
                      });
                      savePreferences();
                    }
                  },
                ),
                const SizedBox(height: SpacingConsts.m),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preferred Foods',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          InputField(
                            controller: _preferredFoodController,
                            hint: 'Add food item',
                            onSubmitted: (_) => addPreferredFood(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: SpacingConsts.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disliked Foods',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: SpacingConsts.s),
                          InputField(
                            controller: _dislikedFoodController,
                            hint: 'Add food item',
                            onSubmitted: (_) => addDislikedFood(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      },
    );
  }
}
