import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson6/model/item_model.dart';

const String Collection = 'Inventory';

class FirestoreController {
  static Future<String> addItem({required Map<String, dynamic> item}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Collection)
        .add(item);
    return ref.id;
  }

  static Future<List<Item>> getItems(
      {required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Collection)
        .where(DocKeyvalue.createdBy.name, isEqualTo: email)
        .orderBy(DocKeyvalue.createdBy.name, descending: true)
        .get();

    List<Item> result = [];
    for (var doc in querySnapshot.docs) {
      var Doc = doc.data() as Map<String, dynamic>;
      var inventory = Item.fromFirestoreDoc(doc: Doc, docId: doc.id);
      result.add(inventory);
    }

    return result;
  }

  static Future<void> update({
    required String docId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(Collection)
        .doc(docId)
        .update(update);
  }

  static Future<void> delete({required String docId}) async {
    await FirebaseFirestore.instance
        .collection(Collection)
        .doc(docId)
        .delete();
  }
}
