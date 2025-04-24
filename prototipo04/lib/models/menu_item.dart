class MenuItem {
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final int? discount;
  final bool isNew;
  final Map<String, String> nutritionalInfo;

  MenuItem({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.discount,
    this.isNew = false,
    required this.nutritionalInfo,
  });
}
