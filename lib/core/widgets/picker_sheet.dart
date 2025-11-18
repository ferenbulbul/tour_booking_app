import 'package:flutter/material.dart';

class PickerSheet extends StatefulWidget {
  final String title;
  final String? initialId;
  final List<PickerOption> options;
  final ScrollController controller;

  const PickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialId,
    required this.controller,
  });

  @override
  State<PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<PickerSheet> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = widget.options
        .where((o) => o.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // handle
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          // title + close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // search field
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Ara...",
            ),
            onChanged: (v) => setState(() => query = v),
          ),

          const SizedBox(height: 16),

          // list
          Expanded(
            child: ListView.builder(
              controller: widget.controller,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final o = filtered[i];
                return ListTile(
                  title: Text(o.name),
                  trailing: o.id == widget.initialId
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () => Navigator.pop(context, o.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PickerOption {
  final String id;
  final String name;

  const PickerOption(this.id, this.name);
}
