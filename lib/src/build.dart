import 'dart:ui';

import 'package:flutter/material.dart';

import 'model/ripple.dart';

class DivisionBuild extends StatelessWidget {
  /// Creates a widget that combines common painting, positioning, and sizing widgets.
  ///
  /// The `height` and `width` values include the padding.
  ///
  /// The `color` argument is a shorthand for `decoration: new
  /// BoxDecoration(color: color)`, which means you cannot supply both a `color`
  /// and a `decoration` argument. If you want to have both a `color` and a
  /// `decoration`, you can pass the color as the `color` argument to the
  /// `BoxDecoration`.
  DivisionBuild({
    Key key,
    this.alignmentChild,
    this.alignment,
    this.padding,
    this.decoration,
    double width,
    double height,
    BoxConstraints constraints,
    this.margin,
    this.transform,
    this.backgroundBlur,
    this.opacity,
    this.ripple,
    this.child,
  })  : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  final Widget child;

  final AlignmentGeometry alignmentChild;

  final AlignmentGeometry alignment;

  final EdgeInsetsGeometry padding;

  final BoxDecoration decoration;

  final BoxConstraints constraints;

  final EdgeInsetsGeometry margin;

  final Matrix4 transform;

  final double backgroundBlur;

  final double opacity;

  final RippleModel ripple;

  EdgeInsetsGeometry get _paddingIncludingDecoration {
    if (decoration == null || decoration.padding == null) return padding;
    final EdgeInsetsGeometry decorationPadding = decoration.padding;
    if (padding == null) return decorationPadding;
    return padding.add(decorationPadding);
  }

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    // container

    if (child == null && (constraints == null || !constraints.isTight)) {
      current = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }

    // child alignment
    if (alignmentChild != null)
      current = Align(alignment: alignmentChild, child: current);

    final EdgeInsetsGeometry effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null)
      current = Padding(padding: effectivePadding, child: current);

    // Material ripple effect
    if (ripple != null && ripple?.enable == true) {
      current = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: decoration?.borderRadius,
          highlightColor: ripple?.highlightColor,
          splashColor: ripple?.splashColor,
          child: current,
        ),
      );
    }

    if (decoration != null)
      current = DecoratedBox(decoration: decoration, child: current);

    if (constraints != null)
      current = ConstrainedBox(constraints: constraints, child: current);

    if (margin != null) current = Padding(padding: margin, child: current);

    // background blur
    if (backgroundBlur != null) {
      current = ClipRRect(
        borderRadius: decoration?.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: backgroundBlur,
            sigmaY: backgroundBlur,
          ),
          child: current,
        ),
      );
    }

    // widget alignment
    if (alignment != null)
      current = Align(alignment: alignment, child: current);

    // transform
    if (transform != null) {
      current = Transform(
        alignment: FractionalOffset.center,
        transform: transform,
        child: current,
      );
    }

    // opacity
    if (opacity != null) current = Opacity(opacity: opacity, child: current);

    return current;
  }
}
