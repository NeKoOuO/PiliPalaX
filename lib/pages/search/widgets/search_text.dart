import 'package:flutter/material.dart';

class SearchText extends StatelessWidget {
  final String? searchText;
  final Function? onSelect;
  final Function? onLongSelect;
  final double? fontSize;
  final Color? bgColor;
  final Color? textColor;
  final TextAlign? textAlign;
  const SearchText({
    super.key,
    this.searchText,
    this.onSelect,
    this.onLongSelect,
    this.fontSize,
    this.bgColor,
    this.textColor,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ??
          Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            onSelect!(searchText);
          },
          onLongPress: () {
            onLongSelect!(searchText);
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 11, right: 11),
            child: Text(
              searchText!,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: fontSize,
                color:
                    textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
