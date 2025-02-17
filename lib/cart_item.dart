class CartItem {
  final String item;
  final String model;
  final String description;
  final int quantity;
  final double actualPrice;
  final double updatedPrice;

  CartItem({
    required this.item,
    required this.model,
    required this.description,
    required this.quantity,
    required this.actualPrice,
    required this.updatedPrice,
  });

  // Add a copyWith method for easy cloning with modifications
  CartItem copyWith({
    String? item,
    String? model,
    String? description,
    int? quantity,
    double? actualPrice,
    double? updatedPrice,
  }) {
    return CartItem(
      item: item ?? this.item,
      model: model ?? this.model,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      actualPrice: actualPrice ?? this.actualPrice,
      updatedPrice: updatedPrice ?? this.updatedPrice,
    );
  }
}