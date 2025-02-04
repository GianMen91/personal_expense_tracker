class Expense {
  final int? id;
  final String category;
  final String description;
  final double cost;
  final DateTime date;

  Expense({
    this.id,
    required this.category,
    required this.description,
    required this.cost,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'cost': cost,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      description: map['description'],
      cost: map['cost'],
      date: DateTime.parse(map['date']),
    );
  }
}
