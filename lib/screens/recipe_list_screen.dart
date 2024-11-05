import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/database_helper.dart';
import 'package:recipe_book/screens/add_update_recipe_screen.dart';
import 'package:recipe_book/screens/recipe_details_screen.dart';



class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> _recipeList;

  @override
  void initState() {
    super.initState();
    _refreshRecipeList();
  }

  void _refreshRecipeList() {
    setState(() {
      _recipeList = DatabaseHelper.instance.getRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Recipes'), backgroundColor: Colors.indigoAccent,),
        body: FutureBuilder<List<Recipe>>(
          future: _recipeList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Recipe> recipes = snapshot.data!;
              if (recipes.isEmpty) {
                return Center(child: Text('No recipes found.'));
              }
              return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    Recipe recipe = recipes[index];
                    return GestureDetector(
                      onTap: () async {
                        bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipe: recipe,
                                )));
                        if (result == true) {
                          _refreshRecipeList();
                        }
                      },
                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  recipe.description.length > 100
                                      ? recipe.description.substring(0, 100) +
                                      '...'
                                      : recipe.description,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ]),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading recipes'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)
            ),
            backgroundColor: Colors.indigoAccent,
            onPressed: () async {
              bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddUpdateRecipeScreen()));
              if (result == true) {
                _refreshRecipeList();
              }
            }));
  }
}