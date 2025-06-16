import 'package:airecipe/models/recipe_model.dart';
import 'package:airecipe/provider/chat_gpt_provider/chat_gpt_provider.dart';
import 'package:airecipe/repository/recipe_repo/recipe_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_provider.g.dart';


@riverpod
RecipeRepo recipeRepo(Ref ref){

 return RecipeRepo(ref.read(dioProvider), ref.read(loggerProvider));

}



@riverpod
class RecipeNotifier extends AutoDisposeAsyncNotifier<RecipeResponse?>{
  @override
  Future<RecipeResponse?> build() async {

    final repo = ref.watch(recipeRepoProvider);
    return await repo.fetchRecipe();

   

  }

  Future<void> filterRecipesByCategory(String category) async {
    state = const AsyncValue.loading();
        final repo = ref.watch(recipeRepoProvider);

    try {
      // Example: Filter recipes by category
      final allRecipes = await repo.fetchRecipe();
      final filteredRecipes = allRecipes?.recipes
          .where((recipe) => recipe.cuisine == category)
          .toList();
      state = AsyncValue.data(RecipeResponse(recipes: filteredRecipes!));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}


