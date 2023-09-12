class CreditCard {
  final int? id;
  final int? cardNumber;
  final int? cvv;
  final String? expirationDate;
  final String? ownerName;

  CreditCard({
    this.id,
    required this.cardNumber,
    required this.cvv,
    required this.expirationDate,
    required this.ownerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'expirationDate': expirationDate,
      'ownerName': ownerName
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      id: map['id'],
      cardNumber: map['cardNumber'],
      cvv: map['cvv'],
      expirationDate: map['expirationDate'],
      ownerName: map['ownerName'],
    );
  }
}
