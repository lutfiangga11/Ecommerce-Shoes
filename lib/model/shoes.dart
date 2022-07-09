class Shoes {
  int idShoes;
  String name;
  double rating;
  List<String>? tags;
  double price;
  List<String> sizes;
  List<String> colors;
  String? description;
  String image;

  Shoes({
    required this.colors,
    this.description,
    required this.idShoes,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.sizes,
    this.tags,
  });

  factory Shoes.fromJson(Map<String, dynamic> json) => Shoes(
        idShoes: int.parse(json['id_shoes']),
        name: json['name'],
        rating: double.parse(json['rating']),
        tags: json['tags'].toString().split(', '),
        price: double.parse(json['price']),
        sizes: json['sizes'].toString().split(', '),
        colors: json['colors'].toString().split(', '),
        description: json['description'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id_shoes': this.idShoes,
        'name': this.name,
        'rating': this.rating,
        'tags': this.tags,
        'price': this.price,
        'sizes': this.sizes,
        'colors': this.colors,
        'description': this.description,
        'image': this.image,
      };
}
