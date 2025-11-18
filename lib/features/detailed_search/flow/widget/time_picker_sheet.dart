import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerSheet extends StatelessWidget {
  final List<String> times;
  final String initial;
  final Function(String) onSelected;

  const TimePickerSheet({
    super.key,
    required this.times,
    required this.initial,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FixedExtentScrollController(
      initialItem: times.indexOf(initial),
    );

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Select Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 44,
              scrollController: controller,
              backgroundColor: Colors.white,
              onSelectedItemChanged: (i) => onSelected(times[i]),
              children: times
                  .map(
                    (e) => Center(
                      child: Text(e, style: const TextStyle(fontSize: 18)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
