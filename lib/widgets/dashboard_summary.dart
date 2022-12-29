import 'package:flutter/material.dart';
import 'package:mobile/widgets/shared/empty_container.dart';
import 'package:provider/provider.dart';

import '../providers/reports_provider.dart';
import '../utils/constants.dart';
import 'shared/loader.dart';

class DashboardSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<ReportsProvider>(context, listen: false).fetchAndSave(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Loader(),
            );
          } else {
            if (data.hasError) {
              return const EmptyContainer(
                  "Something went wrong. Check your Internet");
            } else {
              return Consumer<ReportsProvider>(builder: (ctx, data, _) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildListItem(
                          icon: Icons.check,
                          title: "Validated Today",
                          // amount: data.item.ticketValidated,
                          quantity: data.item.validationsToday,
                          color: Color(0xff3597D4)),
                      _buildListItem(
                          icon: Icons.attach_money,
                          title: "Validated This Week",
                          quantity: data.item.thisWeekValidations,
                          color: Colors.red),
                      _buildListItem(
                          icon: Icons.list_alt_outlined,
                          title: "Validated This Month",
                          quantity: data.item.thisMonthValidations,
                          color: Theme.of(context).accentColor),
                      _buildListItem(
                          icon: Icons.people_alt_outlined,
                          title: "Active Cards",
                          quantity: data.item.activeStudents,
                          color: Theme.of(context).primaryColor),
                      _buildListItem(
                          icon: Icons.person_add_disabled_outlined,
                          title: "Inactive Cards",
                          quantity: data.item.inactiveStudents,
                          color: Theme.of(context).primaryColor),
                    ],
                  ),
                );
              });
            }
          }
        });
  }

  Widget _buildListItem(
      {required IconData icon,
      required String title,
      required Color color,
      int? amount,
      int? quantity}) {
    return ListTile(
      leading: Container(
        child: Icon(
          icon,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.grey[600]),
      ),
      subtitle: amount == null
          ? null
          : Text(
              Utils.numberFormat(amount),
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
      trailing: Text(
        Utils.numberFormat(quantity ?? 0),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
