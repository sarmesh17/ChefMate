import 'package:airecipe/provider/wish_list_provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishListScreen extends ConsumerStatefulWidget {
  const WishListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WishListScreen();
  }
}

class _WishListScreen extends ConsumerState<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final recipeWishList = ref.watch(wishListProvider);

    if (recipeWishList.isEmpty) {
      return noWishListScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Recipes",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: recipeWishList.length,
        itemBuilder: (context, index) {
          final wishedItem = recipeWishList[index];

          return Padding(
            padding: EdgeInsets.all(8.r),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Image.network(
                      width: double.infinity,
                      wishedItem.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            wishedItem.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 4.h),
                          // Rating
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < wishedItem.rating.floor()
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

                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  wishedItem.cookTimeMinutes.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 8),

                                Text(
                                  "min",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 8),

                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(wishListProvider.notifier)
                                        .toggleWishListItem(wishedItem);
                                  },
                                  child: Icon(
                                    ref
                                            .read(wishListProvider.notifier)
                                            .isWishListed(wishedItem)
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        ref
                                            .read(wishListProvider.notifier)
                                            .isWishListed(wishedItem)
                                        ? Colors.teal
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget noWishListScreen() {
    return Scaffold(
      appBar: AppBar(title:  Text(
          "Saved Recipes",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please Save Recipe", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
