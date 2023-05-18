import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Chanaka Ranasinghe"),
            accountEmail: Text("Nipunchanakerane69@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/hh.jpg",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage("assets/ff.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text("Results"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Modules"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text("Lecture Schedule"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.account_box_outlined),
            title: Text("Profile"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: const Text("Info"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out", style: TextStyle(color: Colors.red),),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
