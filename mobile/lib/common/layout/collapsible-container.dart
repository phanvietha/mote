import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class CollapsibleContainer extends StatefulWidget {
  final Duration duration;
  /// Child what will show when expand
  final Widget child;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color iconColor;
  /// Base background widget that fill all container
  final Widget background;
  /// Base height when container collapse
  final double baseHeight;

  const CollapsibleContainer({
    Key key,
    @required this.child,
    @required this.background,
    this.duration = const Duration(milliseconds: 300),
    this.backgroundColor = Colors.grey,
    this.borderRadius,
    this.iconColor = Colors.black,
    this.baseHeight = 250
  })  : assert(background != null, 'Background widget must not be null'),
        assert(child != null, 'Expand child must not be null'),
        super(key: key);

  @override
  _CollapsibleContainerState createState() => _CollapsibleContainerState();
}

class _CollapsibleContainerState extends State<CollapsibleContainer>
    with SingleTickerProviderStateMixin {
  bool _isCollapse = true;
  AnimationController animationController;
  Animation<double> sizedAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    sizedAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  onToggle() {
    setState(() {
      _isCollapse = !_isCollapse;
    });

    switch (sizedAnimation.status) {
      case AnimationStatus.completed:
        animationController.reverse();
        break;
      case AnimationStatus.dismissed:
        animationController.forward();
        break;
      // When in the middle of animating then do nothing
      case AnimationStatus.reverse:
      case AnimationStatus.forward:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                  child: widget.background),
              Column(
                children: [
                  Container(
                    height: widget.baseHeight,
                    padding: EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: FlareActor(
                            'assets/ExpandCollapse.flr',
                            animation: _isCollapse ? 'Collapse' : 'Expand',
                            color: widget.iconColor,
                          ),
                          width: 20,
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: sizedAnimation,
                    axis: Axis.vertical,
                    child: widget.child,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
