import 'package:flutter/material.dart';
import 'package:mobile/providers/history_provider.dart';
import 'package:mobile/providers/history_provider.dart';
import 'package:mobile/widgets/shared/app_drawer.dart';
import 'package:mobile/widgets/shared/card_container.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../widgets/shared/empty_container.dart';
import '../widgets/shared/loader.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: const Text("Validations History")),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder(
              future: Provider.of<HistoryProvider>(context, listen: false)
                  .fetchAndSave(),
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
                    return Consumer<HistoryProvider>(builder: (ctx, data, _) {
                      return Column(
                        children: [
                          ...data.items
                              .map(
                                (e) => SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CardContainer(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${e["student"]["name"]}, ${e["student"]["phoneNumber"]}, ${e["amount"]} RWF",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "Validation succeed",
                                                softWrap: true,
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    timeago.format(
                                                      DateTime.parse(
                                                          e['created_at']),
                                                    ),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      );
                    });
                  }
                }
              })),
    );
  }
}
