class Apparel {
  int idApparel;
  String name;
  double rating;
  List<String>? tags;
  double price;
  List<String> sizes;
  List<String> colors;
  String? description;
  String image;

  Apparel(
      {required this.colors,
      this.description,
      required this.idApparel,
      required this.image,
      required this.name,
      required this.price,
      required this.rating,
      required this.sizes,
      this.tags});

  factory Apparel.fromJson(Map<String, dynamic> json) => Apparel(
      colors: json['colors'].toString().split(', '),
      idApparel: int.parse(json['id_apparel']),
      image: json['image'],
      name: json['name'],
      price: double.parse(json['price']),
      rating: double.parse(json['rating']),
      sizes: json['sizes'].toString().split(', '),
      tags: json['tags'].toString().split(', '),
      description: json['description']);

  Map<String, dynamic> toJson() => {
        'id_apparel': this.idApparel,
        'name': this.name,
        'rating': this.rating,
        'tags': this.tags,
        'price': this.price,
        'sizes': this.sizes,
        'colors': this.colors,
        'description': this.description,
        'image': this.image
      };
}
