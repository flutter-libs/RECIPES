import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/database_helper.dart';


class AddUpdateRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  AddUpdateRecipeScreen({this.recipe});

  @override
  _AddUpdateRecipeScreenState createState() => _AddUpdateRecipeScreenState();
}

class _AddUpdateRecipeScreenState extends State<AddUpdateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _ingredients;
  late String _description;
  late String _steps;

  @override
  void initState() {
    super.initState();
    _title = widget.recipe?.title ?? '';
    _ingredients = widget.recipe?.ingredients ?? '';
    _description = widget.recipe?.description ?? '';
    _steps = widget.recipe?.steps ?? '';
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Recipe recipe = Recipe(
          id: widget.recipe?.id,
          title: _title,
          ingredients: _ingredients,
          description: _description,
          steps: _steps);
      if (widget.recipe == null) {
        await DatabaseHelper.instance.addRecipe(recipe);
      } else {
        await DatabaseHelper.instance.updateRecipe(recipe);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.recipe != null;
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Update Recipe' : 'Add Recipe'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(labelText: 'Title'),
                    onSaved: (value) => _title = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a title';
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _ingredients,
                    decoration: InputDecoration(labelText: 'Ingredients'),
                    onSaved: (value) => _ingredients = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter ingredients';
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _description = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a description';
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _steps,
                    decoration: InputDecoration(labelText: 'Steps'),
                    onSaved: (value) => _steps = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter steps';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _submit,
                      child: Text(isEditing ? 'Update' : 'Add'))
                ]))));
  }
}