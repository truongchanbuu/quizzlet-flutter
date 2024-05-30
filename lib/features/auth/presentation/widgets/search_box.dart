import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
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
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      autofocus: widget.isAutoFocus,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.isAutoFocus
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(Icons.clear))
            : null,
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
