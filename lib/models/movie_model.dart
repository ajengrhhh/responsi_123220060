class FilmModel {
  String? status;
  String? message;
  List<FilmData>? data;

  FilmModel({this.status, this.message, this.data});

  FilmModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FilmData>[];
      json['data'].forEach((v) {
        data!.add(FilmData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilmData {
  int? id;
  String? title;
  int? year;
  double? rating;
  String? imgUrl;
  String? genre;
  String? director;
  String? synopsis;
  String? movieUrl;

  FilmData(
      {this.id,
      this.title,
      this.year,
      this.rating,
      this.imgUrl,
      this.genre,
      this.director,
      this.synopsis,
      this.movieUrl});

  FilmData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    rating = json['rating'] != null ? (json['rating'] as num).toDouble() : null;
    imgUrl = json['imgUrl'];
    genre = json['genre'];
    director = json['director'];
    synopsis = json['synopsis'];
    movieUrl = json['movieUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['year'] = this.year;
    data['rating'] = this.rating;
    data['imgUrl'] = this.imgUrl;
    data['genre'] = this.genre;
    data['director'] = this.director;
    data['synopsis'] = this.synopsis;
    data['movieUrl'] = this.movieUrl;
    return data;
  }
}