import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/view/home_screen.dart';
import 'package:lesson6/model/item_model.dart';

class HomeController {
  HomeState state;

  HomeController(this.state);

  Future<void> signOut() async {
    await firebaseSignOut();
  }

 

  Future<void> loadItemList() async {
    try {
      List<Item> itemList = await FirestoreController.getItems(
          email: state.model.user.email!);
      state.model.ItemList.clear();
      state.model.ItemList.addAll(itemList);
      state.callSetState(() {});
    } catch (e) {
      print("Error fetching inventory: $e");
    } finally {
      state.callSetState(() {});
    }
  }

  void update(String name, int quantity) async {
    int index = state.model.ItemList.indexWhere((item) => item.name == name);
    if (index != -1) {
      Item item = state.model.ItemList[index];
      if (quantity == 0) {
        await FirestoreController.delete(docId: item.docId!);
        state.model.ItemList.removeAt(index);
      } else {
        item.quantity = quantity.toString();
        await FirestoreController.update(
            docId: item.docId!, update: item.toFirestoreDoc());
      }
      state.callSetState(() {});
    }
  }
}
