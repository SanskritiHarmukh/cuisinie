import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorite Recipe'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFFE4AD0C),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF25262A),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe title
                Text(
                  recipe['strMeal'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                // Recipe image
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(recipe['strMealThumb']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Recipe instructions
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  recipe['strInstructions'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE4AD0C), // Set text color to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
