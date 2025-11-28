import 'package:flutter/material.dart';

class ProfessionalSearchBar extends StatefulWidget {
  final Function(String)? onChanged;
  final String hintText;
  final Color mainGreen;
  final Color backgroundColor;

  const ProfessionalSearchBar({
    super.key,
    this.onChanged,
    this.hintText = 'Search quizzes',
    this.mainGreen = const Color(0xFF0D4726),
    this.backgroundColor = const Color(0xFFF2E6D1),
  });

  @override
  State<ProfessionalSearchBar> createState() => _ProfessionalSearchBarState();
}

class _ProfessionalSearchBarState extends State<ProfessionalSearchBar> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.mainGreen.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _isSearching = value.isNotEmpty;
            });
            widget.onChanged?.call(value);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.mainGreen,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: widget.mainGreen,
              size: 22,
            ),
            suffixIcon: _isSearching
                ? GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() {
                        _isSearching = false;
                      });
                      widget.onChanged?.call('');
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: widget.mainGreen,
                      size: 22,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          style: TextStyle(
            color: widget.mainGreen,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: widget.mainGreen,
        ),
      ),
    );
  }
}
