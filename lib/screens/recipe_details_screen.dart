import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/screens/add_update_recipe_screen.dart';
import 'package:recipe_book/models/database_helper.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  void _deleteRecipe(BuildContext context) async {
    await DatabaseHelper.instance.deleteRecipe(recipe.id!);
    Navigator.pop(context, true);
  }

  void _editRecipe(BuildContext context) async {
    bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddUpdateRecipeScreen(recipe: recipe)));
    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.title),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
                icon: Icon(Icons.edit),
                color: Colors.amber,
                onPressed: () {
                  _editRecipe(context);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                color: Colors.redAccent,
                onPressed: () {
                  _deleteRecipe(context);
                }),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(children: [
              Text('Ingredients',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              SizedBox(height: 8),
              Text(recipe.ingredients),
              SizedBox(height: 16),
              Text('Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              SizedBox(height: 8),
              Text(recipe.description),
              SizedBox(height: 16),
              Text('Steps',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              SizedBox(height: 8),
              Text(recipe.steps),
            ])));
  }
}