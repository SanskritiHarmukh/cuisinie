import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionAnalysisPage extends StatefulWidget {
  @override
  _NutritionAnalysisPageState createState() => _NutritionAnalysisPageState();
}

class _NutritionAnalysisPageState extends State<NutritionAnalysisPage> {
  TextEditingController _foodController = TextEditingController();
  Map<String, dynamic>? _nutritionInfo;

  Future<void> fetchNutritionInfo(String food) async {
    final appId = 'api';
    final appKey = 'app id';
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/api/nutrition-data?app_id=$appId&app_key=$appKey&ingr=$food'));

    if (response.statusCode == 200) {
      setState(() {
        _nutritionInfo = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch nutrition information: ${response.statusCode}');
    }
  }

  Widget buildNutritionInfo() {
    List<Widget> nutrientWidgets = [];

    _nutritionInfo!['totalNutrients'].forEach((key, value) {
      String label = value['label'];
      double quantity = value['quantity'];
      String unit = value['unit'];

      nutrientWidgets.add(
        ListTile(
          title: Text(label),
          subtitle: Text('${quantity.toStringAsFixed(2)} $unit'),
        ),
      );
    });

    return Column(
      children: nutrientWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Analysis'),
        backgroundColor: Color(0xFFE4AD0C),
      ),
      backgroundColor: Color(0xFF25262A),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _foodController,
              decoration: InputDecoration(labelText: 'Enter Food intake', labelStyle: TextStyle(color: Color(0xFFE4AD0C)), hintStyle: TextStyle(color: Color(0xFFE4AD0C)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE4AD0C)), // Change the color of the line when focused
                ),),
              style: TextStyle(color: Colors.white),
              cursorColor: Color(0xFFE4AD0C),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchNutritionInfo(_foodController.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(
                    0xFFE4AD0C),
              ),
              child: Text(
                'Get Nutrition Info',
                style: TextStyle(color: Color(
                    0xFF25262A)),
              ),
            ),
            SizedBox(height: 20),
            if (_nutritionInfo != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Color(0xFF959595),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color(0xFFE4AD0C)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Food: ${_nutritionInfo!['ingredients'][0]['parsed'][0]['food']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text('Calories: ${_nutritionInfo!['calories']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Color(0xFF959595),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set border radius
                          side: BorderSide(color: Color(0xFFE4AD0C)), // Set border side
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Nutrients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                              SizedBox(height: 10),
                              buildNutritionInfo(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}