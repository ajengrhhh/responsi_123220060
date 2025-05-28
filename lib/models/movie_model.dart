class Movie {
  final int id;
  final String title;
  final String year;
  final String genre;
  final String director;
  final double rating;
  final String synopsis;
  final String image;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.director,
    required this.rating,
    required this.synopsis,
    required this.image,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      genre: json['genre'],
      director: json['director'],
      rating: (json['rating'] as num).toDouble(),
      synopsis: json['synopsis'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'year': year,
    'genre': genre,
    'director': director,
    'rating': rating,
    'synopsis': synopsis,
    'image': image,
  };
}
