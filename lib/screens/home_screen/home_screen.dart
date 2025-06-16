import 'package:airecipe/models/recipe_model.dart';
import 'package:airecipe/provider/recipe_provider/recipe_provider.dart';
import 'package:airecipe/provider/wish_list_provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  String selectedCategory = 'All';
  bool isLoading = false;
  String? _token;

  // Replace with: user.avatarUrl
  final String greeting =
      "What are you cooking today?"; // Replace with: appConfig.greeting

  final List<String> categories = [
    "American",
    "Asian",
    "Brazilian",
    "Cocktail",
    "Cuban",
    "Greek",
    "Hawaiian",
    "Indian",
    "Italian",
    "Japanese",
    "Korean",
    "Lebanese",
    "Mediterranean",
    "Mexican",
    "Moroccan",
    "Pakistani",
    "Russian",
    "Smoothie",
    "Spanish",
    "Thai",
    "Turkish",
    "Vietnamese",
  ]; // Replace with: categories.map((cat) => cat.name).toList()

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeNotifierProvider).value;
    final wishList = ref.watch(wishListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                _buildSearchBar(),

                SizedBox(height: 24.h),

                // Category Filter
                _buildCategoryFilter(context, ref),
                SizedBox(height: 24.h),

                // Featured Recipes
                _buildFeaturedRecipes(recipes, wishList),

                SizedBox(height: 32.h),

                // New Recipes Section
                _buildNewRecipesSection(recipes),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                // TODO: Implement search functionality
                // searchRecipes(value);
              },
              decoration: InputDecoration(
                hintText: 'Search recipe',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              // TODO: Implement filter functionality
              // showFilterDialog();
            },
            icon: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: EdgeInsets.only(
              right: index == categories.length - 1 ? 0 : 12,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
                // Filter recipes by category
                _filterRecipesByCategory(ref, category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.teal : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to filter recipes by category
  void _filterRecipesByCategory(WidgetRef ref, String category) {
    final recipeNotifier = ref.read(recipeNotifierProvider.notifier);

    // Filter recipes by the selected category
    recipeNotifier.filterRecipesByCategory(category);
  }

  Widget _buildFeaturedRecipes(RecipeResponse? recipes, List<Recipe> wishList) {
    if (recipes == null) {
      // Show loading indicator while fetching data
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes.recipes[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == recipes.recipes.length - 1 ? 0 : 16,
            ),
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to recipe detail
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => RecipeDetailScreen(recipeId: recipe['id'])
                // ));
              },
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Image
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                recipe.image,
                              ), // PLACEHOLDER: Replace with recipe.imageUrl
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  recipe.rating
                                      .toString(), // PLACEHOLDER: Replace with recipe.rating.toString()
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    recipe.cookTimeMinutes
                                        .toString(), // PLACEHOLDER: Replace with recipe.cookingTime
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(wishListProvider.notifier)
                                      .toggleWishListItem(recipe);
                                },
                                child: Icon(
                                  ref
                                          .read(wishListProvider.notifier)
                                          .isWishListed(recipe)
                                      ? Icons.bookmark
                                      : Icons
                                            .bookmark_border, // PLACEHOLDER: Replace with recipe.isFavorite
                                  color:
                                      ref
                                          .read(wishListProvider.notifier)
                                          .isWishListed(recipe)
                                      ? Colors.teal
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewRecipesSection(RecipeResponse? recipes) {
    if (recipes == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipes.recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes.recipes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to recipe detail
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Recipe Image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              recipe.image,
                            ), // PLACEHOLDER: Replace with recipe.imageUrl
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Recipe Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe
                                  .name, // PLACEHOLDER: Replace with recipe.title
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Rating
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < recipe.rating.floor()
                                      ? Icons.star
                                      : Icons
                                            .star_border, // PLACEHOLDER: Replace with recipe.rating
                                  color: Colors.orange,
                                  size: 16,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      // Time
                      Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            recipe.prepTimeMinutes
                                .toString(), // PLACEHOLDER: Replace with recipe.cookingTime
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
