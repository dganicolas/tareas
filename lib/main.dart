import 'package:tareas/database/database_helper.dart';
import 'package:tareas/models/user.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await $FloorDatabaseHelper.databaseBuilder('database.db').build();
  runApp(MainApp(db: db));
}

class MainApp extends StatefulWidget {
  MainApp({required this.db});
  final DatabaseHelper db;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final controller = TextEditingController();
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    widget.db.userDao.readAll().then((value) => setState(() => users = value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: controller,
                )),
                ElevatedButton(
                    onPressed: () async {
                      final name = controller.text;
                      User user = User(name: name);
                      final id = await widget.db.userDao.insertUser(user);
                      user = User(name: name, id: id);
                      setState(() {
                        users.add(user);
                      });
                    },
                    child: const Text('Create User'))
              ],
            ),
          ),
          ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                final user = users[index];
                return ListTileUsers(
                  user: user,
                  db: widget.db,
                  onDelete: () async {
                    await widget.db.userDao.deleteUser(user);
                    setState(() {
                      users.removeWhere((element) => element.id == user.id);
                    });
                  },
                  onUpdate: (updatedUser) {
                    setState(() {
                      final index = users.indexWhere(
                          (element) => element.id == updatedUser.id);
                      if (index == -1) return;
                      setState(() {
                        users[index] = updatedUser;
                      });
                    });
                  },
                );
              })
        ],
      ))),
    );
  }
}

class ListTileUsers extends StatefulWidget {
  const ListTileUsers({
    super.key,
    required this.user,
    required this.db,
    required this.onDelete,
    required this.onUpdate,
  });

  final User user;
  final DatabaseHelper db;
  final Function() onDelete;
  final Function(User) onUpdate;
  @override
  State<ListTileUsers> createState() => _ListTileUsersState();
}

class _ListTileUsersState extends State<ListTileUsers> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('uUSER/${widget.user.id}'),
      leading: Text('${widget.user.id}'),
      title: TextField(
          controller: controller,
          onChanged: (value) {
            final updateUser = widget.user.copyWith(name: value);
            widget.db.userDao.updateUser(updateUser);
            widget.onUpdate(updateUser);
          }),
      trailing: IconButton(
          onPressed: widget.onDelete,
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          )),
    );
  }
}
