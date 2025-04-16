import 'package:flutter/material.dart';

class AnimatedTitle extends StatefulWidget {
  final String text;
  final TextStyle style;
  
  const AnimatedTitle({super.key, required this.text, required this.style});

  @override
  _AnimatedTitleState createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  bool _needsAnimation = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      
      if (textPainter.width > _scrollController.position.viewportDimension && widget.text.length > 17) {
        setState(() => _needsAnimation = true);
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (_needsAnimation) {
                _scrollController.jumpTo(
                  _controller.value * 
                  (widget.text.length * widget.style.fontSize! * 0.6 - constraints.maxWidth),
                );
              }
              return Text(
                widget.text,
                style: widget.style,
                overflow: TextOverflow.visible,
              );
            },
          ),
        );
      },
    );
  }
}


