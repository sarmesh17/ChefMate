import 'package:airecipe/models/recipe_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class RecipeRepo {
  final Dio dio;
  final Logger log;

  RecipeRepo(this.dio, this.log);

  Future<RecipeResponse?> fetchRecipe() async {
    try {
      final result = await dio.get("https://dummyjson.com/recipes?limit=0");

      if (result.statusCode == 200) {
        return RecipeResponse.fromJson(result.data);
      } else {
        log.e("error fetching data");
        return null;
      }
    } catch (e) {
      log.e(e.toString());
      rethrow;
    }
  }

  


  
}
