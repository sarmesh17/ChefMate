import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildHeader extends ConsumerStatefulWidget{
  const BuildHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
       

       return _buildHeader();
  }


  
}

class _buildHeader extends ConsumerState<BuildHeader>{
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ', // PLACEHOLDER: Replace with actual user name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "greeting", // PLACEHOLDER: Replace with dynamic greeting
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(
                "userAvatar,"
              ), // PLACEHOLDER: Replace with user.avatarUrl
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
 
  }



  
}

