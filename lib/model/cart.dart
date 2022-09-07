class Cart {
  int idCart;
  int idUser;
  int idShoes;
  String name;
  double rating;
  List<String>? tags;
  double price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String image;
  int quantity;

  Cart(
      {required this.colors,
      this.description,
      required this.idCart,
      required this.idShoes,
      required this.idUser,
      required this.image,
      required this.name,
      required this.price,
      required this.quantity,
      required this.rating,
      this.sizes,
      this.tags});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      colors: json['colors'],
      idCart: int.parse(json['id_cart']),
      idShoes: int.parse(json['id_shoes']),
      idUser: int.parse(json['id_user']),
      image: json['image'],
      name: json['name'],
      price: double.parse(json['price']),
      quantity: int.parse(json['quantity']),
      rating: double.parse(json['rating']));

  Map<String, dynamic> toJson() => {
        'id_cart': this.idCart,
        'id_shoes': this.idShoes,
        'id_user': this.idUser,
        'quantity': this.quantity
      };
}
