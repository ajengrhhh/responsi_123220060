import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  final _directorController = TextEditingController();
  final _ratingController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newMovie = Movie(
        id: 0, // API will auto-assign ID
        title: _titleController.text,
        year: _yearController.text,
        genre: _genreController.text,
        director: _directorController.text,
        rating: double.parse(_ratingController.text),
        synopsis: _synopsisController.text,
        image: _imageUrlController.text,
      );
      final success = await ApiService.addMovie(newMovie);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add movie')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextFormField(controller: _yearController, decoration: const InputDecoration(labelText: 'Year')),
              TextFormField(controller: _genreController, decoration: const InputDecoration(labelText: 'Genre')),
              TextFormField(controller: _directorController, decoration: const InputDecoration(labelText: 'Director')),
              TextFormField(controller: _ratingController, decoration: const InputDecoration(labelText: 'Rating')),
              TextFormField(controller: _synopsisController, decoration: const InputDecoration(labelText: 'Synopsis')),
              TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Add Movie'))
            ],
          ),
        ),
      ),
    );
  }
}
