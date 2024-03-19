class WasteItem {
  final int id;
  final String name;
  final String type;
  final int quantity;
  final String userId;

  const WasteItem({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.userId,
  });

  factory WasteItem.fromJson(Map<String, dynamic> json) {
    return WasteItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      quantity: json['quantity'],
      userId: json['user_id'],
    );
  }
}