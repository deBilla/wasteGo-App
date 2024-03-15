class WasteItem {
  final int id;
  final String name;
  final String type;
  final int quantity;

  const WasteItem({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
  });

  factory WasteItem.fromJson(Map<String, dynamic> json) {
    return WasteItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      quantity: json['quantity'],
    );
  }

  static getWasteItems() {
    return [
      const WasteItem(id: 1, name: 'News Paper', type: 'paper', quantity: 3),
      const WasteItem(id: 2, name: 'Soda can', type: 'metal', quantity: 4),
      const WasteItem(id: 3, name: 'Hammer', type: 'metal', quantity: 5),
      const WasteItem(id: 4, name: 'Milk Bottle', type: 'glass', quantity: 6)
    ];
  }
}