class Product {
  final String title;
  final String image;
  final double price;
  final String description;

  Product({
    required this.title,
    required this.image,
    required this.price,
    required this.description,
});
  factory Product.fromJson(Map<String,dynamic> json) {
    return Product(
        title: json['title'],
        image: json['image'],
        price: json['price'],
        description: json['description'],
    );
  }
}