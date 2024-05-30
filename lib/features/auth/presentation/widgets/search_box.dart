import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function()? onTap;
  final Function(String value)? onChanged;
  final bool isAutoFocus;
  const SearchBox({
    super.key,
    this.onTap,
    this.onChanged,
    this.isAutoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      autofocus: isAutoFocus,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
        hintText: 'Học phần, sách giáo khoa, câu hỏi',
        fillColor: Colors.white,
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}
