
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/controller/home_controller.dart';
import 'package:lesson6/model/home_model.dart';
import 'package:lesson6/model/item_model.dart';
import 'package:lesson6/controller/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  late HomeController con;
  late HomeModel model;
  String? name; // The item currently being edited
  int? editQuantity; // The temporary quantity being edited

  @override
  void initState() {
    super.initState();
    con = HomeController(this);
    model = HomeModel(currentUser!);
    // Fetch items from Firestore and update the items list
    con.loadItemList();
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
      ),
      body: viewbody(),
      drawer: drawerView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: openDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget drawerView(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('No profile'),
            accountEmail: Text(model.user.email!),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: con.signOut,
          )
        ],
      ),
    );
  }
  Widget viewbody(){
    if(model.ItemList == null){
      return Center(child: Text("Empty Inventory!", style: Theme.of(context).textTheme.titleLarge,),);
    }
    else{
      return viewItemList();
    }
  }

  Widget viewItemList() {
    model.ItemList.sort((a, b) => a.name.compareTo(b.name));

    return ListView.builder(
      itemCount: model.ItemList.length,
      itemBuilder: (context, index) {
        Item item = model.ItemList[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            splashColor: Colors.black,
            splashFactory: InkRipple.splashFactory,
            child: Ink(
              color: name == item.name
                  ? Colors.white
                  : Color.fromRGBO(170, 209, 133, 1),
              child: name == item.name
                  ? buildEditItemView(item.name, int.parse(item.quantity))
                  : ListTile(
                      title: Text(
                        '${item.name} (qty: ${item.quantity})',
                      ),
                      onLongPress: () => setState(() {
                        name = item.name;
                        editQuantity = int.parse(item.quantity);
                      }),
                    ),
            ),
          ),
        );
      },
    );
  }
   void openDialog() {
    TextEditingController itemNameController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(170, 250, 133, 1),
          title: const Text('Add a New Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: itemNameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Name too short';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String name = itemNameController.text.toLowerCase();
                  bool itemExists =
                      model.ItemList.any((item) => item.name == name);
                  if (itemExists) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$name already exists'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Item newItem = Item(
                      createdBy: model.user.email!,
                      name: name,
                      quantity: '1',
                    );
                    String docId = await FirestoreController.addItem(
                        item: newItem.toFirestoreDoc());
                    newItem.docId = docId;
                    model.ItemList.add(newItem);
                    callSetState(() {});
                    Navigator.pop(context);
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Create', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  Widget buildEditItemView(String itemName, int quantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$itemName (qty: $editQuantity)',
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const SizedBox(
              width: 16.0,
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: editQuantity! > 0
                  ? () => setState(() {
                        editQuantity = editQuantity! - 1;
                      })
                  : null,
              color: Colors.red,
            ),
            Text('$editQuantity'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() {
                editQuantity = editQuantity! + 1;
              }),
              color: Colors.blue,
            ),
            const SizedBox(
              width: 16.0,
            ),
            IconButton(
              icon: const Icon(Icons.check),
              color: Colors.blue,
              onPressed: () {
                con.update(itemName, editQuantity!);
                setState(() {
                  name = null;
                  editQuantity = null;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  name = null;
                  editQuantity = null;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
