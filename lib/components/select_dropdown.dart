import 'package:flutter/material.dart';

class SelectDropdown extends StatefulWidget {
  const SelectDropdown({super.key, required this.label, required this.icon});

  final String label;
  final Icon icon;

  @override
  State<SelectDropdown> createState() => _SelectDropdownState();
}

class _SelectDropdownState extends State<SelectDropdown> {
  String? value;

  final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.only(right: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          isExpanded: true,
          items: items.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() {
            this.value = value;
          }),
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
