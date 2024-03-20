class WasteItem {
  final int id;
  final String name;
  final String type;
  final int quantity;
  final String userId;
  final String imageUrl;

  const WasteItem({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.userId,
    required this.imageUrl,
  });

  factory WasteItem.fromJson(Map<String, dynamic> json) {
    return WasteItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      quantity: json['quantity'],
      userId: json['user_id'],
      imageUrl: json['img_url'],
    );
  }
}