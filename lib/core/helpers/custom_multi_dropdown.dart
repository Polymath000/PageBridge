import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



class MultiSelectItem<T> {
  final T value;
  final String label;

  MultiSelectItem({required this.value, required this.label});
}

class CustomMultiDropdown<T> extends StatefulWidget {

  final List<MultiSelectItem<T>> items;

  final List<T> selectedValues;

  final Function(List<T>) onSelectionChanged;

  final String hint;

  final bool searchEnabled;

  final Function(String)? onSearchChange;

  final Color? chipColor;

  final Color? chipLabelColor;

  final ScrollController? scrollController;

  final VoidCallback? onScrollEnd;

  final bool hasMore;

  final Widget? loadingIndicator;



  const CustomMultiDropdown({

    super.key,

    required this.items,

    required this.selectedValues,

    required this.onSelectionChanged,

    this.hint = 'Select items',

    this.searchEnabled = false,

    this.onSearchChange,

    this.chipColor,

    this.chipLabelColor,

    this.scrollController,

    this.onScrollEnd,

    this.hasMore = false,

    this.loadingIndicator,

  });



  @override

  State<CustomMultiDropdown<T>> createState() => _CustomMultiDropdownState<T>();

}



class _CustomMultiDropdownState<T> extends State<CustomMultiDropdown<T>> {

  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  List<T> _selectedValues = [];

  final TextEditingController _searchController = TextEditingController();

  List<MultiSelectItem<T>> _filteredItems = [];



  @override

  void initState() {

    super.initState();

    _selectedValues = List.from(widget.selectedValues);

    _filteredItems = widget.items;

    _searchController.addListener(_onSearchChanged);

    widget.scrollController?.addListener(_onScroll);

  }



  void _onScroll() {

    if (widget.onScrollEnd == null || widget.scrollController == null) return;

    final controller = widget.scrollController!;

    if (controller.position.pixels >=

        controller.position.maxScrollExtent * 0.8) {

      widget.onScrollEnd!();

    }

  }



  @override

  void didUpdateWidget(covariant CustomMultiDropdown<T> oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (widget.selectedValues != oldWidget.selectedValues) {

      _selectedValues = List.from(widget.selectedValues);

    }

    if (widget.onSearchChange == null && widget.items != oldWidget.items) {

      _filteredItems = widget.items;

    } else if (widget.onSearchChange != null) {

      _filteredItems = widget.items;

    }

    if (oldWidget.scrollController != widget.scrollController) {

      oldWidget.scrollController?.removeListener(_onScroll);

      widget.scrollController?.addListener(_onScroll);

    }

  }



  void _onSearchChanged() {

    if (widget.onSearchChange != null) {

      widget.onSearchChange!(_searchController.text);

    } else {

      final query = _searchController.text.toLowerCase();

      setState(() {

        _filteredItems = widget.items

            .where((item) => item.label.toLowerCase().contains(query))

            .toList();

        _updateOverlay();

      });

    }

  }



  void _showOverlay() {

    if (_overlayEntry != null) return;



    final screenSize = MediaQuery.of(context).size;



    _overlayEntry = OverlayEntry(

      builder: (context) {

        return Stack(

          children: [

            Positioned.fill(

              child: GestureDetector(

                onTap: _hideOverlay,

                child: Container(color: Colors.black.withOpacity(0.5)),

              ),

            ),

            Center(

              child: Material(

                elevation: 8,

                borderRadius: BorderRadius.circular(12),

                child: SizedBox(

                  width: screenSize.width * 0.85,

                  child: Column(

                    mainAxisSize: MainAxisSize.min,

                    children: [

                      if (widget.searchEnabled) _buildSearchField(),

                      _buildOptionsList(),

                    ],

                  ),

                ),

              ),

            ),

          ],

        );

      },

    );



    Overlay.of(context).insert(_overlayEntry!);

  }



  void _hideOverlay() {

    if (_overlayEntry != null) {

      _overlayEntry!.remove();

      _overlayEntry = null;

    }



    if (widget.onSearchChange == null) {

      _searchController.clear();

    }

  }



  void _updateOverlay() {

    _overlayEntry?.markNeedsBuild();

  }



  Widget _buildSearchField() {

    return Padding(

      padding: const EdgeInsets.all(8.0),

      child: TextField(

        controller: _searchController,

        decoration: InputDecoration(

          hintText: 'Search...',

          prefixIcon: const Icon(Icons.search),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

        ),

      ),

    );

  }



  Widget _buildOptionsList() {

    final itemsToShow =

        widget.onSearchChange != null ? widget.items : _filteredItems;

    final itemCount = itemsToShow.length + (widget.hasMore ? 1 : 0);



    return ConstrainedBox(

      constraints: BoxConstraints(

        maxHeight: MediaQuery.of(context).size.height * 0.4,

      ),

      child: ListView.builder(

        controller: widget.scrollController,

        padding: EdgeInsets.zero,

        shrinkWrap: false,

        itemCount: itemCount,

        itemBuilder: (context, index) {

          if (index == itemsToShow.length && widget.hasMore) {

            return widget.loadingIndicator ?? const Center(child: CircularProgressIndicator());

          }

          final item = itemsToShow[index];

          final isSelected = _selectedValues.contains(item.value);

          return CheckboxListTile(

            value: isSelected,

            title: Text(item.label),

            onChanged: (bool? selected) {

              setState(() {

                if (selected == true) {

                  _selectedValues.add(item.value);

                } else {

                  _selectedValues.remove(item.value);

                }

                widget.onSelectionChanged(_selectedValues); // Call immediately

                _updateOverlay();

              });

            },

          );

        },

      ),

    );

  }



  @override

  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color fieldBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    final Color borderColor =

        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDDDDDD);

    final Color hintColor =

        isDark ? const Color(0xFFA0A0A0) : const Color(0xFF777777);



    return CompositedTransformTarget(

      link: _layerLink,

      child: GestureDetector(

        onTap: _showOverlay,

        child: Container(

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

          decoration: BoxDecoration(

            color: fieldBg,

            border: Border.all(color: borderColor),

            borderRadius: BorderRadius.circular(12),

          ),

          child: Wrap(

            spacing: 6.0,

            runSpacing: 4.0,

            children: _selectedValues.isEmpty

                ? [

                    Padding(

                      padding: const EdgeInsets.symmetric(vertical: 4.0),

                      child: Text(

                        widget.hint,

                        style: TextStyle(color: hintColor),

                      ),

                    ),

                  ]

                : widget.items

                    .where((item) => _selectedValues.contains(item.value))

                    .map(

                      (item) => Chip(

                        label: Text(

                          item.label,

                          style: TextStyle(

                            color: widget.chipLabelColor ?? Colors.white,

                          ),

                        ),

                        backgroundColor:

                            widget.chipColor ?? const Color(0xFF4CAF50),

                        onDeleted: () {

                          setState(() {

                            _selectedValues.remove(item.value);

                            widget.onSelectionChanged(_selectedValues);

                          });

                        },

                      ),

                    )

                    .toList(),

          ),

        ),

      ),

    );

  }



  @override

  void dispose() {

    _searchController.removeListener(_onSearchChanged);

    _searchController.dispose();

    widget.scrollController?.removeListener(_onScroll);



    if (_overlayEntry != null) {

      _overlayEntry!.remove();

      _overlayEntry = null;

    }



    super.dispose();

  }

}


