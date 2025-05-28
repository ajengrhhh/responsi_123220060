import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class EditPage extends StatefulWidget {
  final Movie movie;

  const EditPage({super.key, required this.movie});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _genreController;
  late TextEditingController _directorController;
  late TextEditingController _ratingController;
  late TextEditingController _synopsisController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.title);
    _yearController = TextEditingController(text: widget.movie.year);
    _genreController = TextEditingController(text: widget.movie.genre);
    _directorController = TextEditingController(text: widget.movie.director);
    _ratingController = TextEditingController(text: widget.movie.rating.toString());
    _synopsisController = TextEditingController(text: widget.movie.synopsis);
    _imageUrlController = TextEditingController(text: widget.movie.image);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedMovie = Movie(
        id: widget.movie.id,
        title: _titleController.text,
        year: _yearController.text,
        genre: _genreController.text,
        director: _directorController.text,
        rating: double.parse(_ratingController.text),
        synopsis: _synopsisController.text,
        image: _imageUrlController.text,
      );
      final success = await ApiService.updateMovie(widget.movie.id, updatedMovie);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update movie')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Movie')),
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
              ElevatedButton(onPressed: _submit, child: const Text('Update Movie'))
            ],
          ),
        ),
      ),
    );
  }
}
