import 'package:airecipe/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBar();
}

class _BottomNavBar extends ConsumerState<BottomNavBar> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.bookmark_border,
    Icons.notifications_none,
    Icons.person_outline,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        context.push(AppRoutes.recipeScreenRoute);
      } else if (index == 1) {
        context.push(AppRoutes.wishListScreenRoute);
      } else if (index == 2) {
        context.push(AppRoutes.notificationScreen);
      } else {
        context.push(AppRoutes.profileScreen);
      }
    });
  }

  Widget _buildIcon(int index) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: Icon(
        _icons[index],
        size: 28,
        color: _selectedIndex == index ? Colors.green : Colors.grey[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIcon(0),
              _buildIcon(1),
              const SizedBox(width: 72),
              _buildIcon(2),
              _buildIcon(3),
            ],
          ),
        ),
        Positioned(
          top: -28,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: FloatingActionButton(
            onPressed: () {
              context.push(AppRoutes.aiRecipeScreen);
            },
            backgroundColor: Colors.green,
            elevation: 4,
            child: Image.asset(
              'assets/images/ai_robo.png',
              width: 32.w,
              height: 32.h,
            ),
          ),
        ),
      ],
    );
  }
}
