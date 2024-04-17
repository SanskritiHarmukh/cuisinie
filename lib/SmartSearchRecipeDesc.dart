import 'package:flutter/material.dart';

class SmartSearchRecipeDesc extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const SmartSearchRecipeDesc({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'],),
        backgroundColor: Color(0xFFE4AD0C),
      ),
      backgroundColor: Color(0xFF25262A),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            Image.network(
              recipe['image'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            // Recipe title
            Text(
              recipe['title'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE4AD0C),
              ),
            ),
            SizedBox(height: 16),
            // Recipe instructions
            Text(
              recipe['instructions'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
