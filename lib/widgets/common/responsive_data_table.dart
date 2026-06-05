import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../utils/responsive.dart';

class ResponsiveDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String? emptyMessage;
  final int rowsPerPage;
  final VoidCallback? onAdd;
  final VoidCallback? onExport;
  final VoidCallback? onRefresh;
  final ValueChanged<String>? onSearch;
  final String title;

  const ResponsiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage,
    this.rowsPerPage = 10,
    this.onAdd,
    this.onExport,
    this.onRefresh,
    this.onSearch,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec titre et actions
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              children: [
                // Titre et boutons principaux
                Row(
                  children: [
                    if (title.isNotEmpty)
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    // Actions wrap sur mobile
                    if (isMobile) ...[
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          if (onAdd != null) const PopupMenuItem(value: 'add', child: Row(children: [Icon(Icons.add, size: 18), SizedBox(width: 8), Text('Ajouter')])),
                          if (onExport != null) const PopupMenuItem(value: 'export', child: Row(children: [Icon(Icons.download, size: 18), SizedBox(width: 8), Text('Exporter')])),
                          if (onRefresh != null) const PopupMenuItem(value: 'refresh', child: Row(children: [Icon(Icons.refresh, size: 18), SizedBox(width: 8), Text('Actualiser')])),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'add': onAdd?.call(); break;
                            case 'export': onExport?.call(); break;
                            case 'refresh': onRefresh?.call(); break;
                          }
                        },
                      ),
                    ] else ...[
                      if (onAdd != null) _ActionButton(icon: Icons.add, label: 'Ajouter', onTap: onAdd!, color: AppColors.primary),
                      if (onAdd != null) const SizedBox(width: 8),
                      if (onExport != null) _ActionButton(icon: Icons.download, label: 'Exporter', onTap: onExport!, color: AppColors.info),
                      if (onExport != null) const SizedBox(width: 8),
                      if (onRefresh != null) _ActionButton(icon: Icons.refresh, label: 'Actualiser', onTap: onRefresh!, color: AppColors.textSecondary),
                    ],
                  ],
                ),
                // Barre de recherche
                if (onSearch != null) ...[
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    onChanged: onSearch,
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Tableau
          if (rows.isEmpty)
            _buildEmptyState()
          else if (isMobile)
            _buildMobileList()
          else
            _buildDesktopTable(),
        ],
      ),
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: WidgetStateProperty.all(AppColors.background),
        dataRowMinHeight: 52,
        dataRowMaxHeight: 52,
        columns: columns,
        rows: rows,
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows.length > 5 ? 5 : rows.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final row = rows[index];
        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          title: row.cells.length > 0 ? row.cells[0].child : const SizedBox(),
          subtitle: row.cells.length > 1 ? row.cells[1].child : null,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: row.cells.skip(1).map((cell) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            columns[row.cells.indexOf(cell)].label.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                        Expanded(child: cell.child),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'Aucune donnée disponible',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
