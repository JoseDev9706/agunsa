import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Paginator extends StatelessWidget {
  final UiUtils uiUtils;
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const Paginator({
    super.key,
    required this.uiUtils,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        if (currentPage > 1)
          GestureDetector(
          onTap: () => onPageChanged(currentPage - 1),
          child: SvgPicture.asset(
            "assets/svg/prev.svg",)
        ),

        
        for (int i = 1; i <= totalPages; i++)
          InkWell(
            onTap: () => onPageChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i == currentPage ? uiUtils.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: i == currentPage ? uiUtils.whiteColor : uiUtils.primaryColor,
                  fontWeight: i == currentPage ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        if (currentPage < totalPages)
        GestureDetector(
          onTap: () => onPageChanged(currentPage + 1),
          child: SvgPicture.asset(
            "assets/svg/next.svg",)
        ),
          
      ],
    );
  }
}
class _PageNumber extends StatelessWidget {
  final UiUtils uiUtils;
  final int pageNumber;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PageNumber({
    required this.uiUtils,
    required this.pageNumber,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isCurrent ? uiUtils.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            color: isCurrent ? uiUtils.whiteColor : uiUtils.whiteColor,
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}