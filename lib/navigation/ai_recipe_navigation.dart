import 'package:airecipe/navigation/app_routes.dart';
import 'package:airecipe/navigation/bottom_nav_bar.dart';
import 'package:airecipe/screens/ai_recipe_screen/ai_recipe_screen.dart';
import 'package:airecipe/screens/auth/loginscreen.dart';
import 'package:airecipe/screens/auth/signup_screen.dart';
import 'package:airecipe/screens/home_screen/home_screen.dart';
import 'package:airecipe/screens/notification_screen/notification_screen.dart';
import 'package:airecipe/screens/profile_screen/profile_screen.dart';
import 'package:airecipe/screens/wish_list_screen/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.loginScreenRoute,
  routes: [
    GoRoute(
      path: AppRoutes.loginScreenRoute,
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.signupScreenRoute,
      builder: (context, state) => SignUpScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(body: child, bottomNavigationBar: BottomNavBar());
      },
      routes: [
        GoRoute(
          path: AppRoutes.recipeScreenRoute,
          builder: (context, state) => RecipeScreen(),
        ),

        GoRoute(
          path: AppRoutes.wishListScreenRoute,
          builder: (context, state) => WishListScreen(),
        ),

        GoRoute(
          path: AppRoutes.notificationScreen,
          builder: (context, state) => NotificationScreen(),
        ),

        GoRoute(path: AppRoutes.profileScreen,builder: (context, state) => ProfileScreen(),)
      ],
    ),

    GoRoute(
      path: AppRoutes.aiRecipeScreen,
      builder: (context, state) => AiRecipeScreen(),
    ),
  ],
);
