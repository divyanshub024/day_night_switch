library day_night_switch;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kTrackHeight = 80.0;
const double _kTrackWidth = 160.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kThumbRadius = 36.0;
const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;
const double _kSwitchWidth = _kTrackWidth - 2 * _kTrackRadius + _kSwitchMinSize;
const double _kSwitchHeight = _kSwitchMinSize + 8.0;

class DayNightSwitch extends StatefulWidget {
  const DayNightSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.sunImage,
    this.moonImage,
    this.sunColor = const Color(0xFFFDB813),
    this.moonColor = const Color(0xFFf5f3ce),
    this.dayColor = const Color(0xFF87CEEB),
    this.nightColor = const Color(0xFF003366),
    this.mouseCursor,
    this.size = const Size(_kSwitchWidth, _kSwitchHeight),
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final DragStartBehavior dragStartBehavior;
  final ImageProvider? sunImage;
  final ImageProvider? moonImage;
  final Color sunColor;
  final Color moonColor;
  final Color dayColor;
  final Color nightColor;
  final MouseCursor? mouseCursor;
  final Size size;

  @override
  State<DayNightSwitch> createState() => _DayNightSwitchState();
}

class _DayNightSwitchState extends State<DayNightSwitch> with TickerProviderStateMixin, ToggleableStateMixin {
  final _painter = _DayNightSwitchPainter();

  @override
  void didUpdateWidget(covariant DayNightSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (position.value == 0.0 || position.value == 1.0) {
        position
          ..curve = Curves.easeIn
          ..reverseCurve = Curves.easeOut;
      }
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged!(value!);
  }

  double get _trackInnerLength => widget.size.width - _kSwitchMinSize;

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / _trackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          positionController.value -= delta;
          break;
        case TextDirection.ltr:
          positionController.value += delta;
          break;
      }
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged!(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final SwitchThemeData switchTheme = SwitchTheme.of(context);

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>((Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states) ??
          switchTheme.mouseCursor?.resolve(states) ??
          MaterialStateProperty.resolveAs<MouseCursor>(MaterialStateMouseCursor.clickable, states);
    });

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: buildToggleable(
          mouseCursor: effectiveMouseCursor,
          size: widget.size,
          painter: _painter
            ..position = position
            ..reaction = reaction
            ..reactionFocusFade = reactionFocusFade
            ..reactionHoverFade = reactionHoverFade
            ..inactiveReactionColor = Colors.transparent
            ..reactionColor = Colors.transparent
            ..hoverColor = Colors.pink
            ..focusColor = Colors.green
            ..splashRadius = kRadialReactionRadius
            ..isFocused = states.contains(MaterialState.focused)
            ..isHovered = states.contains(MaterialState.hovered)
            ..activeColor = Colors.yellow
            ..inactiveColor = Colors.yellow
            ..sunImage = widget.sunImage
            ..moonImage = widget.moonImage
            ..sunColor = widget.sunColor
            ..moonColor = widget.moonColor
            ..dayColor = widget.dayColor
            ..nightColor = widget.nightColor
            ..configuration = createLocalImageConfiguration(context)
            ..textDirection = Directionality.of(context)
            ..isInteractive = isInteractive
            ..trackInnerLength = _trackInnerLength,
        ),
      ),
    );
  }
}

class _DayNightSwitchPainter extends ToggleablePainter {
  ImageProvider? _sunImage;
  ImageProvider? get sunImage => _sunImage;
  set sunImage(ImageProvider? value) {
    if (value == _sunImage) return;
    _sunImage = value;
    notifyListeners();
  }

  ImageProvider? _moonImage;
  ImageProvider? get moonImage => _moonImage;
  set moonImage(ImageProvider? value) {
    if (value == _moonImage) return;
    _moonImage = value;
    notifyListeners();
  }

  Color? _sunColor;
  Color get sunColor => _sunColor!;
  set sunColor(Color value) {
    if (value == _sunColor) return;
    _sunColor = value;
    notifyListeners();
  }

  Color? _moonColor;
  Color get moonColor => _moonColor!;
  set moonColor(Color value) {
    if (value == _moonColor) return;
    _moonColor = value;
    notifyListeners();
  }

  Color? _dayColor;
  Color get dayColor => _dayColor!;
  set dayColor(Color value) {
    if (value == _dayColor) return;
    _dayColor = value;
    notifyListeners();
  }

  Color? _nightColor;
  Color get nightColor => _nightColor!;
  set nightColor(Color value) {
    if (value == _nightColor) return;
    _nightColor = value;
    notifyListeners();
  }

  ImageConfiguration get configuration => _configuration!;
  ImageConfiguration? _configuration;
  set configuration(ImageConfiguration value) {
    if (value == _configuration) return;
    _configuration = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    notifyListeners();
  }

  bool get isInteractive => _isInteractive!;
  bool? _isInteractive;
  set isInteractive(bool value) {
    if (value == _isInteractive) {
      return;
    }
    _isInteractive = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;
  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  bool _isPainting = false;

  void _handleDecorationChanged() {
    // If the image decoration is available synchronously, we'll get called here
    // during paint. There's no reason to mark ourselves as needing paint if we
    // are already in the middle of painting. (In fact, doing so would trigger
    // an assert).
    if (!_isPainting) notifyListeners();
  }

  Color? _cachedThumbColor;
  ImageProvider? _cachedThumbImage;
  BoxPainter? _cachedThumbPainter;

  BoxDecoration _createDefaultThumbDecoration(Color color, ImageProvider? image) {
    return BoxDecoration(
      color: color,
      image: image == null ? null : DecorationImage(image: image),
      shape: BoxShape.circle,
      boxShadow: kElevationToShadow[1],
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bool isEnabled = isInteractive;
    final double currentValue = position.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Color trackColor = Color.lerp(dayColor, nightColor, currentValue)!;
    final Color thumbColor = Color.lerp(sunColor, moonColor, currentValue)!;

    final ImageProvider? thumbImage = isEnabled ? (currentValue < 0.5 ? sunImage : moonImage) : sunImage;
    final trackPaint = Paint()..color = trackColor;
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _kTrackHeight * 0.05 + _kTrackHeight * 0.05 * (1 - currentValue)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final starPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _kTrackHeight * 0.05 * currentValue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Offset trackPaintOffset = _computeTrackPaintOffset(size, _kTrackWidth, _kTrackHeight);
    final double thumbRadius = _kThumbRadius;
    final Offset thumbPaintOffset = _computeThumbPaintOffset(trackPaintOffset, visualPosition, thumbRadius);
    final Offset radialReactionOrigin = Offset(thumbPaintOffset.dx + _kThumbRadius, size.height / 2);

    _paintTrack(canvas, trackPaint, trackPaintOffset);
    _paintBackground(canvas, linePaint, starPaint, trackPaintOffset, currentValue);
    paintRadialReaction(canvas: canvas, origin: radialReactionOrigin);
    _paintThumb(
      canvas,
      thumbPaintOffset,
      currentValue,
      thumbColor,
      thumbImage,
      thumbRadius,
    );
    _paintForegroundLines(canvas, linePaint, trackPaintOffset, currentValue);
  }

  /// Computes canvas offset for track's upper left corner
  Offset _computeTrackPaintOffset(Size canvasSize, double trackWidth, double trackHeight) {
    final double horizontalOffset = (canvasSize.width - _kTrackWidth) / 2.0;
    final double verticalOffset = (canvasSize.height - _kTrackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  /// Computes canvas offset for thumb's upper left corner as if it were a
  /// square
  Offset _computeThumbPaintOffset(Offset trackPaintOffset, double visualPosition, double thumbRadius) {
    // How much thumb radius extends beyond the track
    final double additionalThumbRadius = thumbRadius - _kTrackRadius;

    final double horizontalProgress = visualPosition * trackInnerLength;
    final double thumbHorizontalOffset = trackPaintOffset.dx - additionalThumbRadius + horizontalProgress;
    final double thumbVerticalOffset = trackPaintOffset.dy - additionalThumbRadius;

    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrack(Canvas canvas, Paint paint, Offset trackPaintOffset) {
    final Rect trackRect = Rect.fromLTWH(
      trackPaintOffset.dx,
      trackPaintOffset.dy,
      _kTrackWidth,
      _kTrackHeight,
    );
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      const Radius.circular(_kTrackRadius),
    );
    canvas.drawRRect(trackRRect, paint);
  }

  void _paintBackground(Canvas canvas, Paint paint, Paint starPaint, Offset offset, double currentValue) {
    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.2,
        offset.dy + _kTrackHeight * 0.2,
      ),
      Offset(
        offset.dx + _kTrackWidth * 0.2 + (_kTrackWidth * 0.4) * (1 - currentValue),
        offset.dy + _kTrackHeight * 0.2,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.25,
        offset.dy + _kTrackHeight * 0.8,
      ),
      Offset(
        offset.dx + _kTrackWidth * 0.25 + (_kTrackWidth * 0.3) * (1 - currentValue),
        offset.dy + _kTrackHeight * 0.8,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.1,
        offset.dy + _kTrackHeight * 0.6,
      ),
      Offset(
        offset.dx + _kTrackWidth * 0.1,
        offset.dy + _kTrackHeight * 0.6,
      ),
      starPaint,
    );
  }

  void _paintThumb(
    Canvas canvas,
    Offset thumbPaintOffset,
    double currentValue,
    Color thumbColor,
    ImageProvider? thumbImage,
    double thumbRadius,
  ) {
    try {
      _isPainting = true;
      if (_cachedThumbPainter == null || thumbColor != _cachedThumbColor || thumbImage != _cachedThumbImage) {
        _cachedThumbColor = thumbColor;
        _cachedThumbImage = thumbImage;
        _cachedThumbPainter?.dispose();
        _cachedThumbPainter =
            _createDefaultThumbDecoration(thumbColor, thumbImage).createBoxPainter(_handleDecorationChanged);
      }
      final BoxPainter thumbPainter = _cachedThumbPainter!;

      // The thumb contracts slightly during the animation
      final double inset = 1.0 - (currentValue - 0.5).abs() * 2.0;
      final double radius = thumbRadius - inset;

      thumbPainter.paint(
        canvas,
        thumbPaintOffset - Offset(0, 0),
        configuration.copyWith(size: Size.fromRadius(radius)),
      );

      // canvas.drawCircle(thumbPaintOffset, thumbRadius, Paint()..color = thumbColor);
    } finally {
      _isPainting = false;
    }
  }

  void _paintForegroundLines(Canvas canvas, Paint paint, Offset offset, double currentValue) {
    canvas.drawLine(
      Offset(
        offset.dx + _kTrackWidth * 0.35,
        offset.dy + _kTrackHeight * 0.5,
      ),
      Offset(
        offset.dx + _kTrackWidth * 0.35 + (_kTrackWidth * 0.4) * (1 - currentValue),
        offset.dy + _kTrackHeight * 0.5,
      ),
      paint,
    );
  }

  @override
  void dispose() {
    _cachedThumbPainter?.dispose();
    _cachedThumbPainter = null;
    _cachedThumbColor = null;
    _cachedThumbImage = null;
    super.dispose();
  }
}
