import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charted/file_util.dart';
import 'package:charted/graph_card.dart';
import 'package:charted/main.dart';
import 'package:charted/style_util.dart';

class DetailsDialog extends StatefulWidget {
  final GraphCard parent;
  final Map<DateTime, double> data;

  const DetailsDialog({super.key, required this.parent, required this.data});

  @override
  State<StatefulWidget> createState() => DetailsDialogState();
}

class DetailsDialogState extends State<DetailsDialog> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainPageState>();

    var parent = widget.parent;
    var entries = getSortedEntries(widget.data);

    return AlertDialog(
      scrollable: true,
      backgroundColor: darkColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleOf(parent.name),
          for (var entry in entries)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(children: [
                formatDate(entry.key),
                formatTime(
                    TimeOfDay(hour: entry.key.hour, minute: entry.key.minute))
              ]),
              largeStyled(formatDouble(entry.value)),
              IconButton(
                onPressed: () {
                  if (widget.data.length == 1) {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      parent.data.remove(entry.key);
                      appState.notify();
                    });
                  } else {
                    setState(() {
                      widget.data.remove(entry.key);
                      appState.notify();
                    });
                  }

                  eraseDatum(widget.parent.name, entry.key);
                },
                icon: const Icon(Icons.remove_circle_outline, color: red),
              )
            ])
        ],
      ),
    );
  }
}
