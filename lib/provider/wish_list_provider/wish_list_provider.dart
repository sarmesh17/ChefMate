
import 'package:airecipe/models/recipe_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wish_list_provider.g.dart';

@riverpod
class WishList extends _$WishList {

  @override
  List<Recipe> build () =>[];

  void toggleWishListItem(Recipe recipe){

   if (state.any((r) => r.id == recipe.id)) {
     
     state = state.where((r) => r.id != recipe.id).toList();
   }else{

    state = [...state,recipe];
   }

  }

  bool isWishListed(Recipe recipe){

    return state.any((r) => r.id == recipe.id);

  }



}