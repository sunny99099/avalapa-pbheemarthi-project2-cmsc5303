enum DocKeyvalue {
  name,
  quantity,
  createdBy,
}

class Item {
  String? docId;
  String createdBy;
  String name;
  String quantity;

  Item({
    this.docId,
    required this.createdBy,
    required this.name,
    required this.quantity,
  });

  factory Item.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return Item(
      docId: docId,
      createdBy: doc[DocKeyvalue.createdBy.name] ?? '',
      name: doc[DocKeyvalue.name.name] ?? '',
      quantity: doc[DocKeyvalue.quantity.name] ?? '',
    );
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyvalue.name.name: name,
      DocKeyvalue.createdBy.name: createdBy,
      DocKeyvalue.quantity.name: quantity,
    };
  }

  static String? validatety(String? value) {
    return value == null || value.trim().length < 3 ? 'Title too short' : null;
  }
}
