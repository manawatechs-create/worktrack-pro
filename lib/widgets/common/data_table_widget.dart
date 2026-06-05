import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class AppDataTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String? emptyMessage;
  final int rowsPerPage;
  final VoidCallback? onAdd;
  final VoidCallback? onExport;
  final VoidCallback? onRefresh;
  final ValueChanged<String>? onSearch;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage,
    this.rowsPerPage = 10,
    this.onAdd,
    this.onExport,
    this.onRefresh,
    this.onSearch,
  });

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  int _currentPage = 0;
  String _searchQuery = '';
  int _rowsPerPage = 10;

  int get _pageCount => (widget.rows.length / _rowsPerPage).ceil();
  
  List<DataRow> get _paginatedRows {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    if (start >= widget.rows.length) return [];
    return widget.rows.sublist(start, end > widget.rows.length ? widget.rows.length : end);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Barre d'actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (widget.onAdd != null)
                  ElevatedButton.icon(
                    onPressed: widget.onAdd,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Ajouter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                if (widget.onExport != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onExport,
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Exporter'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                  ),
                ],
                if (widget.onRefresh != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onRefresh,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Actualiser'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                  ),
                ],
                const Spacer(),
                if (widget.onSearch != null)
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchQuery = '';
                                  widget.onSearch?.call('');
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      onChanged: (v) {
                        _searchQuery = v;
                        widget.onSearch?.call(v);
                        setState(() => _currentPage = 0);
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Tableau
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: widget.rows.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            widget.emptyMessage ?? 'Aucune donnée disponible',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : DataTable(
                    columnSpacing: 20,
                    headingRowColor: WidgetStateProperty.all(AppColors.background),
                    columns: widget.columns,
                    rows: _paginatedRows,
                  ),
          ),
          
          // Pagination
          if (widget.rows.length > _rowsPerPage)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Text(
                    'Affichage de ${_currentPage * _rowsPerPage + 1} à ${(_currentPage + 1) * _rowsPerPage > widget.rows.length ? widget.rows.length : (_currentPage + 1) * _rowsPerPage} sur ${widget.rows.length} enregistrements',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Rows per page
                      Text('Lignes par page:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: _rowsPerPage,
                        items: [5, 10, 25, 50].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                        onChanged: (v) => setState(() { _rowsPerPage = v!; _currentPage = 0; }),
                        underline: const SizedBox(),
                      ),
                      const SizedBox(width: 16),
                      // Previous
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                        iconSize: 20,
                      ),
                      // Pages
                      ...List.generate(_pageCount > 5 ? 5 : _pageCount, (i) {
                        int pageNum;
                        if (_pageCount <= 5) {
                          pageNum = i;
                        } else if (_currentPage < 2) {
                          pageNum = i;
                        } else if (_currentPage > _pageCount - 3) {
                          pageNum = _pageCount - 5 + i;
                        } else {
                          pageNum = _currentPage - 2 + i;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            onTap: () => setState(() => _currentPage = pageNum),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _currentPage == pageNum ? AppColors.primary : null,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${pageNum + 1}',
                                style: TextStyle(
                                  color: _currentPage == pageNum ? Colors.white : AppColors.textPrimary,
                                  fontWeight: _currentPage == pageNum ? FontWeight.bold : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      // Next
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPage < _pageCount - 1 ? () => setState(() => _currentPage++) : null,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
