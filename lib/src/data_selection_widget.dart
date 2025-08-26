// Multi Items Select along with search functionality

import 'package:custom_multi_search/custom_multi_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class DataSelectionWidget<T> extends StatefulWidget {
  const DataSelectionWidget({
    super.key,
    required this.store,
    required this.hint,
    this.labelStr,
    required this.nameExtractor,
    this.onChanged,
    this.validator,
    this.errorMsg,
    this.initialValue,
    this.defaultValue,
    this.isMandatory = false,
    this.isLoading,
    this.itemBuilder,
  });
  final DataSelectionStore<T> store;
  final String hint;
  final String? labelStr;
  final String Function(T) nameExtractor;
  final void Function(List<T>)? onChanged;
  final FormFieldValidator<List<T>>? validator;
  final String? errorMsg;
  final List<T>? initialValue;
  final List<T>? defaultValue;
  final bool isMandatory;
  final bool? isLoading;
  final Widget Function(BuildContext, T, bool)? itemBuilder;

  @override
  State<DataSelectionWidget<T>> createState() => _DataSelectionWidgetState<T>();
}

class _DataSelectionWidgetState<T> extends State<DataSelectionWidget<T>> {
  late final TextEditingController _controller;
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Sync controller with store's searchQuery
    _disposer = reaction((_) => widget.store.searchQuery, (String query) {
      if (_controller.text != query) {
        _controller.text = query;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    });

    // Initialize confirmedItems with initialValue
    if (widget.initialValue != null && widget.store.confirmedItems.isEmpty) {
      widget.store.confirmedItems.addAll(widget.initialValue!);
    }
  }

  @override
  void dispose() {
    _disposer();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelStr != null || widget.isMandatory)
            Row(
              children: [
                Text(
                  widget.labelStr ?? '',
                ),
                if (widget.isMandatory) ...[
                  const SizedBox(width: 5),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          const SizedBox(height: 6),
          widget.isLoading ?? false
              ? const CircularProgressIndicator()
              : _buildSearchField(context, colorScheme),
          const SizedBox(height: 12),
          Observer(
            builder: (_) => AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOut,
              height: widget.store.isExpanded ? 260 : 0,
              child: widget.store.isExpanded
                  ? _buildItemsContainer(context, colorScheme)
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 20),
          if (widget.errorMsg != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.errorMsg!,
              ),
            ),
          _buildConfirmedItems(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, ColorScheme colorScheme) {
    return Observer(
      builder: (_) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            suffixIcon: widget.store.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.store.setSearchQuery('');
                    },
                  )
                : AnimatedRotation(
                    turns: widget.store.isExpanded ? 0.5 : 0,
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.expand_more_rounded,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      onPressed: () => widget.store.toggleExpansion(),
                    ),
                  ),
          ),
          onChanged: widget.store.setSearchQuery,
          onTap: () {
            if (!widget.store.isExpanded) {
              widget.store.setExpansion(true);
            }
          },
        ),
      ),
    );
  }

  Widget _buildItemsContainer(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Observer(
                builder: (_) {
                  if (widget.store.filteredItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'no_items_found',
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    itemCount: widget.store.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.store.filteredItems[index];
                      return Observer(
                        builder: (_) {
                          final isSelected = widget.store.isItemActive(item);
                          if (widget.itemBuilder != null) {
                            return widget.itemBuilder!(
                                context, item, isSelected);
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              color: isSelected
                                  ? colorScheme.primaryContainer
                                      .withValues(alpha: 0.3)
                                  : Colors.transparent,
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                checkboxTheme: CheckboxThemeData(
                                  fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return colorScheme
                                            .primary; // Vibrant primary when checked
                                      }
                                      return Colors.grey
                                          .shade200; // Light grey when unchecked
                                    },
                                  ),
                                  checkColor: WidgetStateProperty.all<Color>(
                                    Colors.white,
                                  ), // White tick mark
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.5,
                                      ), // Border color
                                      width: 2,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4,
                                    ), // Rounded square
                                  ),
                                  visualDensity: const VisualDensity(
                                    horizontal: 1,
                                    vertical: 1,
                                  ), // Slightly larger
                                ),
                              ),
                              child: CheckboxListTile(
                                key: ValueKey(item),
                                title: Text(
                                  widget.nameExtractor(item),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    widget.store.toggleItemSelection(item);
                                  }
                                },
                                activeColor: colorScheme.primary,
                                checkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Observer(
                  builder: (_) => Text(
                    '${widget.store.selectedItems.length} selected}',
                  ),
                ),
                Observer(
                  builder: (_) => ElevatedButton.icon(
                    onPressed: widget.store.selectedItems.isNotEmpty ||
                            widget.store.confirmedItems.isNotEmpty
                        ? () {
                            widget.store.confirmSelection();
                            widget.store.setExpansion(false);
                            widget.onChanged?.call(
                                widget.store.confirmedItems.toList().cast<T>());
                          }
                        : null,
                    icon: const Icon(Icons.check_rounded, size: 20),
                    label: Text(
                      'confirm',
                      style: TextStyle(
                          color: (widget.store.selectedItems.isNotEmpty ||
                                  widget.store.confirmedItems.isNotEmpty)
                              ? Colors.white
                              : Colors.grey),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmedItems(BuildContext context, ColorScheme colorScheme) {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 24,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Selected Items',
              ),
              const SizedBox(width: 8),
              if (widget.store.confirmedItems.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.store.confirmedItems.length}',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          widget.store.confirmedItems.isNotEmpty
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.store.confirmedItems.map((item) {
                      return Chip(
                        label: Text(
                          widget.nameExtractor(item),
                        ),
                        deleteIcon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                        onDeleted: () {
                          widget.store.removeConfirmedItem(item);
                          widget.onChanged?.call(
                              widget.store.confirmedItems.toList().cast<T>());
                        },
                        backgroundColor: colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
                      );
                    }).toList(),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 48,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No items selected yet',
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Start by searching and selecting items above',
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
