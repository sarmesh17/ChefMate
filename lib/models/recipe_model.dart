import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_model.freezed.dart';
part 'recipe_model.g.dart';

@freezed
class RecipeResponse with _$RecipeResponse {
  const factory RecipeResponse({
    required List<Recipe> recipes,
  }) = _RecipeResponse;

  factory RecipeResponse.fromJson(Map<String, dynamic> json) =>
      _$RecipeResponseFromJson(json);
}

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required int id,
    required String name,
    required List<String> ingredients,
    required List<String> instructions,
    required int prepTimeMinutes,
    required int cookTimeMinutes,
    required int servings,
    required String difficulty,
    required String cuisine,
    required int caloriesPerServing,
    required List<String> tags,
    required int userId,
    required String image,
    required double rating,
    required int reviewCount,
    required List<String> mealType,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);
}
