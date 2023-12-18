class AddToCart {
  final String id;
  final String title;
  final double price;
  final double totalPrice;
  final String? description;
  final String? category;
  final String? available;
  final int quantity;

  AddToCart({
    required this.id,
    required this.title,
    required this.price,
    required this.totalPrice,
    this.description,
    this.category,
    this.available,
    required this.quantity,
  });

  static AddToCart fromJson(Map<String, dynamic> json) => AddToCart(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        totalPrice: json['price'],
        description: json['description'],
        category: json['category'],
        available: json['available'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'totalPrice': totalPrice,
        'description': description,
        'category': category,
        'available': available,
        'quantity': quantity,
      };
}
