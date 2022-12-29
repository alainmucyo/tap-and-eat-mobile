import 'package:flutter/material.dart';
import 'package:mobile/screens/add-students.screen.dart';
import 'package:mobile/screens/topup.screen.dart';
import 'package:mobile/screens/validate-students.screen.dart';
import 'package:provider/provider.dart';

import '../../screens/dashboard.screen.dart';
import '../../screens/history.screen.dart';
import '../../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  Widget _menuItem(IconData icon, String title, VoidCallback tapedHandler) {
    return ListTile(
      leading: Icon(icon, color: CustomColor.DARK_GREY),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: CustomColor.DARK_GREY),
      ),
      onTap: tapedHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          // color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Tap & Eat",
                  style: TextStyle(fontSize: 30, color: CustomColor.DARK_GREY)),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 0),
                  children: [
                    _menuItem(
                      Icons.dashboard_outlined,
                      "Dashboard",
                      () => Navigator.pushReplacementNamed(
                          context, DashboardScreen.routeName),
                    ),
                    const Divider(),
                    _menuItem(
                      Icons.people_alt_outlined,
                      "Add Students",
                      () => Navigator.pushReplacementNamed(
                          context, AddStudentsScreen.routeName),
                    ),
                    const Divider(),
                    _menuItem(
                      Icons.nfc,
                      "Validate Students",
                      () => Navigator.pushReplacementNamed(
                          context, ValidateStudentsScreen.routeName),
                    ),
                  /*  const Divider(),
                    _menuItem(
                      Icons.money,
                      "Topup Card",
                      () => Navigator.pushReplacementNamed(
                          context, TopupScreen.routeName),
                    ),*/
                    const Divider(),
                    _menuItem(
                      Icons.library_books_outlined,
                      "History",
                      () => Navigator.pushReplacementNamed(
                          context, HistoryScreen.routeName),
                    ),
                    /*  const Divider(),
                    _menuItem(
                      Icons.person_outlined,
                      "My Account",
                      () => Navigator.pushReplacementNamed(
                          context, MyAccountScreen.routeName),
                    ),*/
                    const Divider(),
                    _menuItem(Icons.exit_to_app, "Logout", () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                  "Do you want to logout the application?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                          color: CustomColor.DARK_GREY),
                                    )),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Utils.logout(context);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style:
                                        TextStyle(color: CustomColor.PRIMARY),
                                  ),
                                )
                              ],
                            );
                          });
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
