class StockModel {
  final int? id;
  final String name;
  final int quantity;
  final DateTime addedDate;

  StockModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.addedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      addedDate: DateTime.parse(map['addedDate']),
    );
  }
}
