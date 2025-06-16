import 'package:airecipe/models/chat_gpt_model/chat_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ChatRepo {
  final Dio dio;
  final Logger logger;
  ChatRepo(this.dio, this.logger);

  Future<ChatCompletion> fetchResponse(String userInput) async {
    // Simple validation: only allow input containing 'ingredients'
    final allowedKeywords = [
      'ingredients',
      'recipe',
      'chicken',
      'rice',
      'tomato',
      'garlic',
      'egg',
      'spinach',
      'cheese',
      'pasta',
      'oil',
      'onion',
    ];
    final lowercaseInput = userInput.toLowerCase();

    final containsValidIngredient = allowedKeywords.any(
      (ingredient) => lowercaseInput.contains(ingredient),
    );

    if (!containsValidIngredient) {
      throw Exception(
        "Invalid input. Please provide a list of ingredients or a recipe-related query.",
      );
    }

    try {
      final response = await dio.post(
        'https://api.aimlapi.com/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer 231aac9ced5f4e578d880003a56c8fcf',
            'Content-Type': 'application/json',
            'Accept': '*/*',
          },
        ),
        data: {
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful assistant that creates recipes based on ingredients provided by the user.",
            },
            {"role": "user", "content": userInput},
          ],
          "temperature": 1,
          "max_tokens": 512,
        },
      );

      logger.i('Response: ${response.data}');
      return ChatCompletion.fromJson(response.data);
    } catch (e) {
      logger.e("Chat API Error", error: e);
      rethrow;
    }
  }
}
