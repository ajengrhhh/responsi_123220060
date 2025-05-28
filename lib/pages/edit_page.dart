import 'package:flutter/material.dart';
import 'package:responsi/models/movie_model.dart';
import 'package:responsi/services/movie_service.dart';
import 'home_page.dart'; // Ganti sesuai dengan halaman utama kamu

class EditFilmPage extends StatefulWidget {
  final int id;
  const EditFilmPage({super.key, required this.id});

  @override
  State<EditFilmPage> createState() => _EditFilmPageState();
}

class _EditFilmPageState extends State<EditFilmPage> {
  final title = TextEditingController();
  final year = TextEditingController();
  final rating = TextEditingController();
  final imgUrl = TextEditingController();
  final genre = TextEditingController();
  final director = TextEditingController();
  final synopsis = TextEditingController();
  final movieUrl = TextEditingController();

  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Film"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _filmWidget(),
      ),
    );
  }

 Widget _filmWidget() {
  return FutureBuilder<FilmData>(
    future: ApiService.getFilmById(widget.id),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error.toString()}");
      } else if (snapshot.hasData) {
        if (!_isDataLoaded) {
          _isDataLoaded = true;
          FilmData film = snapshot.data!;  // langsung Film, bukan Map
          title.text = film.title!;
          year.text = film.year!.toString();
          rating.text = film.rating!.toString();
          genre.text = film.genre!;
          director.text = film.director!;
          synopsis.text = film.synopsis!;
        }

        return _filmEditForm(context);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}

  Widget _filmEditForm(BuildContext context) {
    return ListView(
      children: [
        _textField(title, "Title"),
        _textField(year, "Year"),
        _textField(rating, "Rating"),
        _textField(genre, "Genre"),
        _textField(director, "Director"),
        _textField(synopsis, "Synopsis"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _updateFilm(context),
          child: const Text("Update Film"),
        ),
      ],
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Future<void> _updateFilm(BuildContext context) async {
    try {
      int? yearInt = int.tryParse(year.text.trim());
      double? ratingDouble = double.tryParse(rating.text.trim());

      if (yearInt == null || ratingDouble == null) {
        throw Exception("Tahun dan rating harus berupa angka.");
      }

      FilmData updatedFilm = FilmData(
        id: widget.id,
        title: title.text.trim(),
        year: yearInt,
        rating: ratingDouble,
        genre: genre.text.trim(),
        director: director.text.trim(),
        synopsis: synopsis.text.trim(),
      );

      await ApiService.updateFilm(updatedFilm);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Film '${updatedFilm.title}' berhasil diperbarui")),
      );

      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage(username: 'admin',)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error")),
      );
    }
  }
}