class Product {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String category;
  final String available;
  final String supplierName;
  final String supplierAddress;
  final String description;
 

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.category,
    required this.available,
    required this.supplierName,
    required this.supplierAddress,
    required this.description,
  
  });

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
        category: json['category'],
        available: json['available'],
        supplierName: json['supplierName'],
        supplierAddress: json['supplierAddress'],
        description: json['description'],
        
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'quantity': quantity,
        'category': category,
        'available': available,
        'supplierName': supplierName,
        'supplierAddress': supplierAddress,
        'description': description,
        
      };
}
