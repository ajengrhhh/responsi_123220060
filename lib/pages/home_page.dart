import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import 'detail_page.dart';
import 'edit_page.dart';
import 'create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = ApiService.fetchMovies();
  }

  void _refreshMovies() {
    setState(() {
      _movies = ApiService.fetchMovies();
    });
  }

  void _deleteMovie(int id) async {
    final success = await ApiService.deleteMovie(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie deleted')),
      );
      _refreshMovies();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete movie')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = '123220060';

    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, $username'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(movie.image, width: 50, fit: BoxFit.cover),
                    title: Text(movie.title),
                    subtitle: Text('${movie.year} | Rating: ${movie.rating}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailPage(movie: movie)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditPage(movie: movie)),
                          ).then((_) => _refreshMovies()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMovie(movie.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load movies'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreatePage()),
        ).then((_) => _refreshMovies()),
      ),
    );
  }
}
