import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'RecipeDetailsPage.dart';
import 'CalendarPage.dart';
import 'ProfilePage.dart';
import 'SmartSearchPage.dart';
import 'NutritionAnalysisPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipeSearchResults = [];
  List<dynamic> _videoSearchResults = [];

  void _searchRecipes(String query, String apiKey) async {
    // Search for recipes using MealDB API
    final recipeResponse = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));
    if (recipeResponse.statusCode == 200) {
      setState(() {
        _recipeSearchResults = json.decode(recipeResponse.body)['meals'];
      });
    } else {
      throw Exception('Failed to load recipe search results');
    }

    final refinedQuery = '$query recipe';

    final videoResponse = await http.get(Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$refinedQuery&type=video&key=$apiKey'));
    if (videoResponse.statusCode == 200) {
      setState(() {
        _videoSearchResults = json.decode(videoResponse.body)['items'];
      });
    } else {
      throw Exception('Failed to load video search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // No shadow
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE4AD0C),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF25262A),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/Cuisinie.png'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 16),
                    child: Icon(Icons.account_circle_outlined, color: Color(0xFF959595), size: 40),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What would you like to cook today?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFD9DEEE),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Color(0xFFE4AD0C),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF323337),
                        hintText: 'Search recipe using ingredients...',
                        hintStyle: TextStyle(color: Color(0xFF959595)),
                        contentPadding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF959595)),
                      ),
                      style: TextStyle(color: Color(0xFF959595)),
                      onSubmitted: (value) {
                        _searchRecipes(value, 'api key');
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarPage()),
                      );
                    },
                    child: Icon(Icons.calendar_month, color: Color(0xFF959595), size: 40,),
                  ),
                  SizedBox(width: 10),
                  // Cooking events icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NutritionAnalysisPage()),
                      );
                    },
                    child: Icon(Icons.analytics, color: Color(0xFF959595), size: 40,),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SmartSearchPage()),
                      );
                    },
                    child: Icon(Icons.camera_alt, color: Color(0xFF959595), size: 40,),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Recipes'),
                          Tab(text: 'Videos'),
                        ],
                        indicatorColor: Color(0xFFE4AD0C),
                        labelColor: Color(0xFFE4AD0C),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildRecipeSearchResults(),
                            _buildVideoSearchResults(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSearchResults() {
    if (_recipeSearchResults.isEmpty) {
      return Center(
        child: Text('No recipes found'),
      );
    } else {
      return ListView.builder(
        itemCount: _recipeSearchResults.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> recipe = _recipeSearchResults[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(recipe: recipe),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(recipe['strMealThumb']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe title
                        Text(
                          recipe['strMeal'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE4AD0C),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          recipe['strInstructions'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _addToCalendar(recipe);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _addToCalendar(Map<String, dynamic> recipe) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((selectedDate) {
      if (selectedDate != null) {
        _addRecipeToCalendar(recipe, selectedDate);
      }
    });
  }

  void _addRecipeToCalendar(Map<String, dynamic> recipe, DateTime selectedDate) {
    // Implement adding recipe to calendar logic here
  }

  Widget _buildVideoSearchResults() {
    if (_videoSearchResults.isEmpty) {
      return Center(
        child: Text('No videos found'),
      );
    } else {
      return ListView.builder(
        itemCount: _videoSearchResults.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              String videoId = _videoSearchResults[index]['id']['videoId'];
              String videoUrl = 'https://www.youtube.com/watch?v=$videoId';
              _launchURL(videoUrl);
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(_videoSearchResults[index]['snippet']['thumbnails']['medium']['url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video title
                        Text(
                          _videoSearchResults[index]['snippet']['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE4AD0C),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _videoSearchResults[index]['snippet']['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
