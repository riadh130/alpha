class MemberModel {
  final String? id;
  final String name;
  final String phone;
  final String email;
  final String subscriptionType;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'left'

  MemberModel({
    this.id,
    required this.name,
    required this.phone,
    this.email = '',
    required this.subscriptionType,
    required this.price,
    required this.startDate,
    required this.endDate,
    this.status = 'active',
  });

  // Convertit un objet Member en Map pour l'envoyer à Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'subscriptionType': subscriptionType,
      'price': price,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }

  // Crée un objet Member à partir d'une Map venant de Firestore
  factory MemberModel.fromMap(Map<String, dynamic> map, String id) {
    return MemberModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      subscriptionType: map['subscriptionType'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      status: map['status'] ?? 'active',
    );
  }
}