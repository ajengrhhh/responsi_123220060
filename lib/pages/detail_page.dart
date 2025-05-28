import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;

  const DetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(movie.image, height: 200),
            SizedBox(height: 16),
            Text('Name: ${movie.title}', style: TextStyle(fontSize: 18)),
            Text('Director: ${movie.director}'),
            Text('Genre: ${movie.genre}'),
            Text('Year: ${movie.year}'),
            Text('Rating: ${movie.rating} / 10'),
            SizedBox(height: 16),
            Text('Synopsis:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(movie.synopsis),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ganti dengan URL film jika tersedia
              },
              child: Text('Movie Website'),
            ),
          ],
        ),
      ),
    );
  }
}
