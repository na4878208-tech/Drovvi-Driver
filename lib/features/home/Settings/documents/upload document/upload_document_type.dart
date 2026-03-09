import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';

class DocumentTypeField extends StatefulWidget {
  final String label;
  final String? selectedValue;
  final Map<String, dynamic> items;
  final Function(String) onSelected;

  const DocumentTypeField({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<DocumentTypeField> createState() => _DocumentTypeFieldState();
}

class _DocumentTypeFieldState extends State<DocumentTypeField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool isOpen = false;

  bool get hasValue =>
      widget.selectedValue != null && widget.selectedValue!.isNotEmpty;

  void toggleDropdown() {
    if (isOpen) {
      closeDropdown();
    } else {
      openDropdown();
    }
  }

  void openDropdown() {
    if (_overlayEntry != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);

      setState(() {
        isOpen = true;
      });
    });
  }

  void closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      isOpen = false;
    });
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: closeDropdown,
          behavior: HitTestBehavior.translucent,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: _layerLink,
                  offset: Offset(0, size.height + 6), // EXACTLY BELOW FIELD
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: size.width,
                      constraints: const BoxConstraints(maxHeight: 250),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: widget.items.entries.map((e) {
                          return ListTile(
                            title: Text(e.value),
                            onTap: () {
                              widget.onSelected(e.key);
                              closeDropdown();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldFloat = hasValue;

    final borderRadius = BorderRadius.circular(12);

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// FIELD
            InkWell(
              onTap: toggleDropdown,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: AppColors.electricTeal),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: AppColors.electricTeal,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        hasValue
                            ? widget.items[widget.selectedValue]
                            : widget.label,
                        style: TextStyle(
                          color: hasValue ? AppColors.darkText : Colors.grey,
                        ),
                      ),
                    ),

                    Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),

            /// FLOATING LABEL
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              left: 12,
              top: shouldFloat ? -20 : 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: shouldFloat ? 1 : 0,
                child: Container(
                  color: AppColors.lightGrayBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.electricTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
