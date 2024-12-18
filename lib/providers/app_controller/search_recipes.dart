import 'package:app_controller_client/app_controller_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:intellicook_mobile/providers/app_controller/app_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_recipes.g.dart';

@riverpod
class SearchRecipes extends _$SearchRecipes {
  @override
  Future<SearchRecipesState> build() async {
    return const SearchRecipesState.none();
  }

  Future<void> searchRecipes(List<String> ingredients) async {
    final client = ref.watch(appControllerProvider).client;
    final api = client.getRecipeSearchApi();
    final prevState = state.value;
    final searchMore = prevState?.ingredients == ingredients;
    final page = searchMore ? prevState!.page + 1 : 1;

    state = const AsyncLoading();

    try {
      final requestBuilder = SearchRecipesPostRequestModelBuilder()
        ..ingredients = ListBuilder(ingredients)
        ..page = page
        ..perPage = 10
        ..includeDetail = true;

      final response = await api.recipeSearchSearchRecipesPost(
        searchRecipesPostRequestModel: requestBuilder.build(),
      );

      state = AsyncData(SearchRecipesState.success(
        ingredients,
        page,
        response.data!.recipes.toList(),
      ));
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final problemDetails = e.response!.data as Map<String, dynamic>;
        if (problemDetails['errors'] is Map<String, dynamic>) {
          final errors = problemDetails['errors'] as Map<String, dynamic>;

          final keyToErrorKey = <String, SearchRecipesStateErrorKey>{
            'Ingredients': SearchRecipesStateErrorKey.ingredients,
            'Page': SearchRecipesStateErrorKey.page,
            'PerPage': SearchRecipesStateErrorKey.perPage,
          };

          final errorMap = {
            for (final e in keyToErrorKey.entries)
              e.value: (List<String>.from(errors[e.key] ?? []))
          };
          errorMap[SearchRecipesStateErrorKey.unspecified] = List<String>.from(
            errors.entries
                .where((e) => !keyToErrorKey.containsKey(e.key))
                .map((e) => e.value)
                .expand((e) => e)
                .toList(),
          );

          state = AsyncData(SearchRecipesState.error(errorMap));
          return;
        }
      }

      state = AsyncError(e, e.stackTrace);
      rethrow;
    }
  }
}

enum SearchRecipesStateErrorKey {
  ingredients,
  page,
  perPage,
  unspecified,
}

class SearchRecipesState {
  const SearchRecipesState.none()
      : ingredients = const [],
        page = 1,
        response = const [],
        errors = null;

  const SearchRecipesState.success(this.ingredients, this.page, this.response)
      : errors = null;

  const SearchRecipesState.error(
    this.errors,
  )   : ingredients = null,
        page = 1,
        response = const [];

  final List<String>? ingredients;
  final int page;

  final List<SearchRecipesRecipeModel> response;
  final Map<SearchRecipesStateErrorKey, List<String>>? errors;
}
