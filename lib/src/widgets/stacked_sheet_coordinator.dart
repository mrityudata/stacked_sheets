import 'package:flutter/material.dart';
import 'package:stacked_sheets/src/controller/stacked_sheet_controller.dart';
import 'package:stacked_sheets/src/model/stacked_sheet_model.dart';

/// A widget that coordinates the display of stacked bottom sheets.
///
/// This widget should wrap the part of your application where you want
/// the sheets to appear (usually around your [Scaffold]). It listens to the
/// provided [StackedSheetController] and manages an [OverlayEntry] to
/// display the sheets.
class StackedSheetCoordinator extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// The controller that manages the stack of sheets.
  final StackedSheetController controller;

  /// Creates a [StackedSheetCoordinator].
  const StackedSheetCoordinator({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<StackedSheetCoordinator> createState() =>
      _StackedSheetCoordinatorState();
}

class _StackedSheetCoordinatorState extends State<StackedSheetCoordinator> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncOverlayWithController);

    // Ensure we sync initial state after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncOverlayWithController();
    });

  }

  @override
  void didUpdateWidget(StackedSheetCoordinator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncOverlayWithController);
      widget.controller.addListener(_syncOverlayWithController);
      _syncOverlayWithController();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncOverlayWithController);
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _syncOverlayWithController() {
    if (!mounted) return; // Guard against disposed state
    if (widget.controller.hasSheets) {
      if (_overlayEntry == null) {
        _overlayEntry = OverlayEntry(
          builder: (context) =>
              _StackedSheetStackPresenter(controller: widget.controller),
        );
        final overlay = Overlay.of(context, debugRequiredFor: widget);
        overlay.insert(_overlayEntry!);
      } else {
        _overlayEntry?.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _StackedSheetStackPresenter extends StatelessWidget {
  final StackedSheetController controller;
  const _StackedSheetStackPresenter({required this.controller});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Stack(
          children: [
            // Dark dim overlay behind everything
            if (controller.hasSheets)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => controller.pop(),
                  child: Container(color: Colors.black45),
                ),
              ),
            // Map each sheet in the state to a stack layer
            ...controller.sheets.asMap().entries.map((entry) {
              int index = entry.key;
              StackedSheet sheet = entry.value;
              int distanceFromTop = controller.sheets.length - 1 - index;

              // Visual depth clamping: stop visual changes after 3 layers deep
              // This prevents sheets from becoming too small or flying off screen
              int visualDepth = distanceFromTop.clamp(0, 10);

              // Parallax scaling and offset calculations based on clamped depth
              double targetScale = 1.0 - (visualDepth * 0.05);
              double targetYOffset = visualDepth * 16.0;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                left: 0,
                right: 0,
                bottom: 0,
                top: targetYOffset + (mediaQuery.size.height * (1 - sheet.initialExtent)),
                child: AnimatedScale(
                  scale: targetScale,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  alignment: Alignment.topCenter,
                  child: Material(
                    elevation: 16,
                    color: sheet.backgroundColor,
                    borderRadius: sheet.borderRadius,
                    clipBehavior: Clip.antiAlias,
                    child: sheet.child,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
