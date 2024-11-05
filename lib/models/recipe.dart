import 'dart:convert';

class Recipe {
  int? id;
  String title;
  String ingredients;
  String description;
  String steps;

  Recipe({this.id, required this.title, required this.ingredients, required this.description, required this.steps});

  // Convert a Recipe into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'description': description,
      'steps': steps
    };
  }
}