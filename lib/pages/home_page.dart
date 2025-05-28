import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import 'detail_page.dart';
import 'create_page.dart';
import 'edit_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<FilmData>> _movies;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _movies = ApiService.getFilms();
    });
  }


  void _navigateToEdit(FilmData movie) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditFilmPage(id: movie.id!),
      ),
    );


    if (result == true) {
      _refresh(); // refresh only if movie was updated
    }
  }

  void _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePage()),
    );

    if (result == true) {
      _refresh(); // refresh only if new movie was created
    }
  }

  void _navigateToDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(id: id)),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildMovieItem(FilmData movie) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: movie.imgUrl != null && movie.imgUrl!.isNotEmpty
            ? Image.network(
                movie.imgUrl!,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.movie),
              )
            : const Icon(Icons.movie, size: 50),
        title: Text(movie.title ?? 'No Title'),
        subtitle: Text('${movie.year ?? '-'} | Rating: ${movie.rating?.toStringAsFixed(1) ?? '-'}'),
        onTap: () => _navigateToDetail(movie.id!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _navigateToEdit(movie),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final success = await ApiService.deleteMovie(movie.id!);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Movie deleted")),
                  );
                  _refresh();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete movie")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.username}'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') _logout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<FilmData>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load movies"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No movies available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => _buildMovieItem(snapshot.data![index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add),
      ),
    );
  }
}
