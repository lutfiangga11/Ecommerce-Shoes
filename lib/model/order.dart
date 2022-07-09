class Order {
  int idOrder;
  int idUser;
  String listShop;
  String delivery;
  String payment;
  String? note;
  double total;
  String image;
  String arrived;
  DateTime dateTime;

  Order({
    required this.idOrder,
    required this.arrived,
    required this.delivery,
    required this.idUser,
    required this.image,
    required this.listShop,
    this.note,
    required this.payment,
    required this.total,
    required this.dateTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        arrived: json['arrived'],
        delivery: json['delivery'],
        idOrder: int.parse(json['id_order']),
        idUser: int.parse(json['id_user']),
        image: json['image'],
        listShop: json['list_shop'],
        payment: json['payment'],
        total: double.parse(json['total']),
        note: json['note'],
        dateTime: DateTime.parse(json['date_time']),
      );

  Map<String, dynamic> toJson(String imageBase64) => {
        'delivery': this.delivery,
        'id_order': this.idOrder.toString(),
        'id_user': this.idUser.toString(),
        'image': this.image,
        'image_file': imageBase64,
        'list_shop': this.listShop,
        'payment': this.payment,
        'total': this.total.toStringAsFixed(2),
        'note': this.note ?? '',
      };
}
