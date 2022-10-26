import 'package:flutter/material.dart';
import 'package:sakay_v2/models/dropdown_items.dart';

class SelectDropdown extends StatefulWidget {
  const SelectDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.itemOptions,
    required this.callback,
    required this.defaultValue,
  });

  final String label;
  final Icon? icon;
  final List<dynamic> itemOptions;
  final DropdownItems? defaultValue;
  final Function(DropdownItems? value) callback;

  @override
  State<SelectDropdown> createState() => _SelectDropdownState();
}

class _SelectDropdownState extends State<SelectDropdown> {
  String? value;

  DropdownMenuItem<DropdownItems> buildMenuItem(item) => DropdownMenuItem(
        value: item,
        child: Text(item.name),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.only(right: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          isExpanded: true,
          items: widget.itemOptions.map(buildMenuItem).toList(),
          value: widget.defaultValue,
          onChanged: widget.callback,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: widget.icon,
            floatingLabelStyle: const TextStyle(
              color: Color.fromARGB(255, 130, 157, 72),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: const UnderlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
