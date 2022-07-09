class Cart {
  int idCart;
  int idUser;
  int idShoes;
  String name;
  double rating;
  List<String>? tags;
  double price;
  List<String> sizes;
  List<String> colors;
  String? description;
  String image;
  int quantity;
  String color;
  String size;

  Cart({
    required this.colors,
    this.description,
    required this.idCart,
    required this.idShoes,
    required this.idUser,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.sizes,
    this.tags,
    required this.quantity,
    required this.color,
    required this.size,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        idCart: int.parse(json['id_cart']),
        idShoes: int.parse(json['id_shoes']),
        idUser: int.parse(json['id_user']),
        name: json['name'],
        rating: double.parse(json['rating']),
        tags: json['tags'].toString().split(', '),
        price: double.parse(json['price']),
        sizes: json['sizes'].toString().split(', '),
        colors: json['colors'].toString().split(', '),
        description: json['description'],
        image: json['image'],
        quantity: int.parse(json['quantity']),
        color: json['color'],
        size: json['size'],
      );

  Map<String, dynamic> toJson() => {
        'id_cart': this.idCart,
        'id_shoes': this.idShoes,
        'id_User': this.idUser,
        'quantity': this.quantity,
        'color': this.color,
        'size': this.size,
      };
}
