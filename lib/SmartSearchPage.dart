import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:http/http.dart' as http;
import 'SmartSearchRecipeDesc.dart';

class SmartSearchPage extends StatefulWidget {
  @override
  _SmartSearchPageState createState() => _SmartSearchPageState();
}

class _SmartSearchPageState extends State<SmartSearchPage> {
  File? _image;
  String _result = '';
  bool _loading = false;
  List<Map<String, dynamic>> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future classifyImage() async {
    setState(() {
      _loading = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      var prediction = await Tflite.runModelOnImage(
        path: _image!.path,
        numResults: 1,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      if (prediction != null && prediction.isNotEmpty) {
        setState(() {
          _result = prediction[0]['label']
              ?.split(' ')
              .last ?? '';
          _loading = false;
        });

        // After getting the result, fetch recipes
        fetchRecipes(_result);
      }
    }
  }

  Future<void> fetchRecipes(String ingredient) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?i=$ingredient'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['meals'];
      setState(() {
        _recipes = data.map((meal) {
          return {
            'title': meal['strMeal'],
            'image': meal['strMealThumb'],
            'id': meal['idMeal'],
            // Use meal ID to fetch detailed instructions later
          };
        }).toList();
      });

      // Fetch detailed instructions for each recipe
      await fetchInstructions();
    } else {
      print('Failed to load recipes: ${response.statusCode}');
    }
  }

  Future<void> fetchInstructions() async {
    for (var recipe in _recipes) {
      final id = recipe['id'];
      final response = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['meals'][0];
        final ingredients = _extractIngredients(responseData);
        setState(() {
          recipe['instructions'] = responseData['strInstructions'];
          recipe['ingredients'] = ingredients;
        });
      } else {
        print('Failed to load instructions for recipe $id: ${response
            .statusCode}');
      }
    }
  }

  List<String> _extractIngredients(Map<String, dynamic> meal) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      if (meal['strIngredient$i'] != null && meal['strIngredient$i']
          .trim()
          .isNotEmpty) {
        ingredients.add('${meal['strIngredient$i']} - ${meal['strMeasure$i']}');
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Search'),
        backgroundColor: Color(0xFFE4AD0C),
      ),
      backgroundColor: Color(0xFF25262A),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding vertically
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE4AD0C)), // Add border
                  borderRadius: BorderRadius.circular(10.0), // Add rounded corners
                ),
                child: _image == null
                    ? Center(
                  child: Text('No image selected.', style: TextStyle(color: Colors.white)),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Result: $_result',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: classifyImage,
              style: ElevatedButton.styleFrom(primary: Color(0xFFE4AD0C)),
              child: Text(
                'Classify Image',
                style: TextStyle(color: Color(0xFF25262A)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(recipe: _recipes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SmartSearchRecipeDesc(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe['image'],
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              recipe['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE4AD0C)),
            ),
            SizedBox(height: 8),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildIngredientsList(recipe['ingredients']),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList(List<String>? ingredients) {
    if (ingredients == null || ingredients.isEmpty) {
      return [Text('No ingredients available', style: TextStyle(color: Colors.white))];
    }
    return ingredients.map((ingredient) => Text(ingredient, style: TextStyle(color: Colors.white))).toList();
  }
}

