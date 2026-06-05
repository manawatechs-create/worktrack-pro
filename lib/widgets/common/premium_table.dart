import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class PremiumColumn {
  final String label;
  final IconData? icon;
  final bool numeric;
  const PremiumColumn({required this.label, this.icon, this.numeric = false});
}

class PremiumRow {
  final List<PremiumCell> cells;
  final bool highlighted;
  const PremiumRow({required this.cells, this.highlighted = false});
}

class PremiumCell {
  final Widget widget;
  final String value;
  const PremiumCell({required this.widget, this.value = ''});
}

class PremiumTable extends StatefulWidget {
  final List<PremiumColumn> columns;
  final List<PremiumRow> rows;
  final String? title;
  final String? subtitle;
  final bool showSearch;
  final bool showAdd;
  final bool showExport;
  final bool showRefresh;
  final VoidCallback? onAdd;
  final VoidCallback? onExport;
  final VoidCallback? onRefresh;
  final String? emptyMessage;

  const PremiumTable({
    super.key,
    required this.columns,
    required this.rows,
    this.title,
    this.subtitle,
    this.showSearch = true,
    this.showAdd = true,
    this.showExport = true,
    this.showRefresh = true,
    this.onAdd,
    this.onExport,
    this.onRefresh,
    this.emptyMessage,
  });

  @override
  State<PremiumTable> createState() => _PremiumTableState();
}

class _PremiumTableState extends State<PremiumTable> {
  String _search = '';
  int _currentPage = 0;
  int _rowsPerPage = 10;

  List<PremiumRow> get _filteredRows {
    if (_search.isEmpty) return widget.rows;
    return widget.rows.where((r) {
      return r.cells.any((c) => c.value.toLowerCase().contains(_search.toLowerCase()));
    }).toList();
  }

  int get _totalPages => (_filteredRows.length / _rowsPerPage).ceil();
  
  List<PremiumRow> get _pagedRows {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    if (start >= _filteredRows.length) return [];
    return _filteredRows.sublist(start, end > _filteredRows.length ? _filteredRows.length : end);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Header
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              if (widget.title != null)
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(widget.title!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    if (widget.subtitle != null) Text(widget.subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                ),
              if (widget.showAdd) _btn('Ajouter', Icons.add, AppColors.primary, widget.onAdd),
              if (widget.showAdd) const SizedBox(width: 6),
              if (widget.showExport) _btn('Export', Icons.download, AppColors.info, widget.onExport),
              if (widget.showExport) const SizedBox(width: 6),
              if (widget.showRefresh) _btn('Actualiser', Icons.refresh, AppColors.secondary, widget.onRefresh),
            ]),
            if (widget.showSearch) ...[
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher...', hintStyle: TextStyle(fontSize: 13, color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search, size: 18, color: AppColors.textHint),
                  suffixIcon: _search.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() { _search = ''; _currentPage = 0; })) : null,
                  filled: true, fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), isDense: true,
                ),
                onChanged: (v) => setState(() { _search = v; _currentPage = 0; }),
              ),
            ],
          ]),
        ),

        // Tableau
        if (_filteredRows.isEmpty)
          _buildEmpty()
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.background),
              headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary),
              dataTextStyle: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              dataRowMinHeight: 48, dataRowMaxHeight: 56,
              columnSpacing: 20, horizontalMargin: 20,
              columns: widget.columns.map((c) => DataColumn(
                label: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (c.icon != null) ...[Icon(c.icon, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6)],
                  Text(c.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
              )).toList(),
              rows: _pagedRows.map((r) => DataRow(
                color: r.highlighted ? WidgetStateProperty.all(AppColors.primary.withOpacity(0.02)) : null,
                cells: r.cells.map((c) => DataCell(c.widget)).toList(),
              )).toList(),
            ),
          ),

        // Pagination
        if (_totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: AppColors.background, border: Border(top: BorderSide(color: AppColors.border))),
            child: Row(children: [
              Text('${_currentPage * _rowsPerPage + 1}-${(_currentPage + 1) * _rowsPerPage > _filteredRows.length ? _filteredRows.length : (_currentPage + 1) * _rowsPerPage} sur ${_filteredRows.length}',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.chevron_left, size: 18), onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null),
              ...List.generate(_totalPages > 5 ? 5 : _totalPages, (i) {
                int p = _totalPages <= 5 ? i : (_currentPage < 2 ? i : _currentPage > _totalPages - 3 ? _totalPages - 5 + i : _currentPage - 2 + i);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () => setState(() => _currentPage = p),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: _currentPage == p ? AppColors.primary : null, borderRadius: BorderRadius.circular(4)),
                      child: Text('${p + 1}', style: TextStyle(color: _currentPage == p ? Colors.white : AppColors.textPrimary, fontSize: 12)),
                    ),
                  ),
                );
              }),
              IconButton(icon: const Icon(Icons.chevron_right, size: 18), onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null),
            ]),
          ),
      ]),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.inbox, size: 48, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(widget.emptyMessage ?? 'Aucune donnée', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
      ]),
    );
  }

  Widget _btn(String label, IconData icon, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.2))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
