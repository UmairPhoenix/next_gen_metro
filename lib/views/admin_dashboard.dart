// admin_dashboard.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:file_saver/file_saver.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

import 'package:next_gen_metro/services/api_service.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _ManageRoutesPage(),
    _ManageUsersPage(),
    _ManageFaresPage(), // NEW
  ];

  final List<String> _titles = [
    "Manage Routes",
    "Manage Users",
    "Manage Fares", // NEW
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              color: darkBrown,
              gradient: LinearGradient(
                colors: [darkBrown, darkBrown.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Center(
              child: Text(
                _titles[_selectedIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          selectedItemColor: darkBrown,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Routes'),
            BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fares'), // NEW
          ],
        ),
      ),
    );
  }
}

/// ---------------------------- ROUTES PAGE ----------------------------

class _ManageRoutesPage extends StatefulWidget {
  const _ManageRoutesPage();

  @override
  State<_ManageRoutesPage> createState() => _ManageRoutesPageState();
}

class _ManageRoutesPageState extends State<_ManageRoutesPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController(); // used as "service"
  final startController = TextEditingController();
  final endController = TextEditingController();

  // NEW: cities
  final startCityController = TextEditingController();
  final endCityController = TextEditingController();

  // Optional helper for dropdown
  final List<String> _services = const ['Orange', 'Speedo', 'Metro'];
  String? _selectedService;

  List<dynamic> routes = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    startController.dispose();
    endController.dispose();
    startCityController.dispose();
    endCityController.dispose();
    super.dispose();
  }

  Future<void> _fetchRoutes() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await ApiService.fetchRoutes();
      setState(() => routes = data);
    } catch (e) {
      setState(() => error = e.toString());
      _snack('Failed to load routes');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _addRoute() async {
    if (!_formKey.currentState!.validate()) return;

    // validate service value explicitly
    final svc = categoryController.text.trim();
    if (!_services.contains(svc)) {
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(
          title: "Invalid Service",
          message: "Service must be one of: Orange, Speedo, Metro.",
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);
    try {
      await ApiService.addRoute(
        name: nameController.text.trim(),
        category: svc, // mapped to "service" in ApiService
        start: startController.text.trim(),
        end: endController.text.trim(),
        startCity: startCityController.text.trim(),
        endCity: endCityController.text.trim(),
      );
      nameController.clear();
      categoryController.clear();
      startController.clear();
      endController.clear();
      startCityController.clear();
      endCityController.clear();
      _selectedService = null;

      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.success(
          title: "Route Added",
          message: "The route has been created successfully.",
        ),
      );

      await _fetchRoutes();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(
          title: "Add Failed",
          message: e.toString(),
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _fetchRoutes,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Card(
              title: "Add New Route",
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _LabeledField(controller: nameController, label: "Route Name"),
                    // Keep your original field but make it a dropdown UX-wise while still writing to controller
                    DropdownButtonFormField<String>(
                      value: _selectedService,
                      items: _services
                          .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedService = v;
                          categoryController.text = v ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Service (Orange/Speedo/Metro)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    SizedBox(height: 10.h),
                    // Keep your original text field too (requested: don't remove anything)
                    _LabeledField(controller: categoryController, label: "Service (Orange/Speedo/Metro)"),
                    _LabeledField(controller: startController, label: "Start Point"),
                    _LabeledField(controller: endController, label: "End Point"),
                    // NEW: cities
                    _LabeledField(controller: startCityController, label: "Start City"),
                    _LabeledField(controller: endCityController, label: "End City"),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isSubmitting ? null : _addRoute,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBrown,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.add, color: Colors.white),
                        label: const Text("Add Route", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _SectionHeader(
              title: "Existing Routes",
              trailing: IconButton(
                tooltip: "Refresh",
                icon: const Icon(Icons.refresh),
                onPressed: _fetchRoutes,
              ),
            ),
            if (error != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _InlineError(
                  message: error!,
                  onRetry: _fetchRoutes,
                ),
              ),
            if (routes.isEmpty)
              _EmptyState(
                icon: Icons.route,
                title: "No routes yet",
                subtitle: "Add your first route with the form above.",
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final r = (routes[index] as Map<String, dynamic>);
                final name = (r['name'] ?? '').toString();
                final service = (r['service'] ?? r['category'] ?? '').toString(); // support old field
                final start = (r['start'] ?? '').toString();
                final end = (r['end'] ?? '').toString();
                final startCity = (r['startCity'] ?? '').toString();
                final endCity = (r['endCity'] ?? '').toString();

                final subtitle = [
                  "From $start to $end",
                  if (startCity.isNotEmpty || endCity.isNotEmpty) "($startCity → $endCity)",
                  " • $service"
                ].where((s) => s.trim().isNotEmpty).join('  ');

                return Card(
                  elevation: 1.5,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: darkBrown.withOpacity(0.1),
                      child: const Icon(Icons.alt_route, color: Colors.black87),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(subtitle),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------- USERS PAGE ----------------------------

class _ManageUsersPage extends StatefulWidget {
  const _ManageUsersPage();

  @override
  State<_ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<_ManageUsersPage> {
  List<dynamic> users = [];
  bool isLoading = true;
  String? error;
  int? deletingId;

  // Selection & filter
  final Set<int> selectedIds = {};
  bool selectAll = false;
  String search = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
      error = null;
      selectedIds.clear();
      selectAll = false;
    });
    try {
      final data = await ApiService.fetchUsers(); // GET /admin/users (fallback to /users)
      setState(() => users = data);
    } catch (e) {
      setState(() => error = e.toString());
      _snack('Failed to load users');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteUserFlow(int id, String nameOrEmail) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: "Delete User",
        message: "Are you sure you want to delete “$nameOrEmail”? This action cannot be undone.",
        confirmLabel: "Delete",
        confirmColor: Colors.red,
      ),
    );
    if (confirm != true) return;

    setState(() => deletingId = id);
    try {
      await ApiService.deleteUser(id); // DELETE /admin/users/:id (fallback to /users/:id)
      _snack('User deleted');
      await _fetchUsers();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(title: "Delete failed", message: e.toString()),
      );
    } finally {
      if (mounted) setState(() => deletingId = null);
    }
  }

  void _toggleSelectAll(bool? value, List<Map<String, dynamic>> displayList) {
    final v = value ?? false;
    setState(() {
      selectAll = v;
      selectedIds.clear();
      if (v) {
        for (final u in displayList) {
          final id = (u['id'] ?? u['userId'] ?? 0) as int;
          final role = (u['role'] ?? '').toString().toLowerCase();
          if (role != 'admin') selectedIds.add(id);
        }
      }
    });
  }

  void _toggleOne(int id, bool? value) {
    setState(() {
      if (value == true) {
        selectedIds.add(id);
      } else {
        selectedIds.remove(id);
      }
    });
  }

  bool _isAdmin(Map<String, dynamic> u) => (u['role'] ?? '').toString().toLowerCase() == 'admin';

  List<Map<String, dynamic>> get _filtered {
    final q = search.trim().toLowerCase();
    final list = users.cast<Map<String, dynamic>>();
    if (q.isEmpty) return list;
    return list
        .where((u) =>
            (u['name'] ?? '').toString().toLowerCase().contains(q) ||
            (u['email'] ?? '').toString().toLowerCase().contains(q) ||
            (u['role'] ?? '').toString().toLowerCase().contains(q))
        .toList();
  }

  Future<void> _exportSheet() async {
    final displayList = _filtered;
    final nonAdminDisplay =
        displayList.where((u) => !_isAdmin(u)).map((u) => (u['id'] ?? u['userId'] ?? 0) as int).toList();

    final selectedCount = selectedIds.isEmpty ? nonAdminDisplay.length : selectedIds.length;

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Export Users", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 8.h),
              Text(
                selectedIds.isEmpty
                    ? "No users selected. Exporting all visible non-admin users (${nonAdminDisplay.length})."
                    : "Exporting $selectedCount selected users.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _exportSelectedToExcel();
                      },
                      icon: const Icon(Icons.grid_on),
                      label: const Text('Export .xlsx'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: darkBrown),
                      onPressed: () {
                        Navigator.pop(context);
                        _exportSelectedToCsvFallback();
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('Export .csv', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              const Text(
                "Tip: If .xlsx fails (e.g., license), use CSV. Excel opens CSV fine.",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportSelectedToExcel() async {
    final dataToExport = _dataToExport();
    if (dataToExport.isEmpty) {
      _snack('No users to export');
      return;
    }

    try {
      final book = xlsio.Workbook();
      final sheet = book.worksheets[0];
      sheet.name = 'Users';

      final headers = ['ID', 'Name', 'Email', 'Role'];
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle
          ..bold = true
          ..hAlign = xlsio.HAlignType.center;
      }

      for (int r = 0; r < dataToExport.length; r++) {
        final u = dataToExport[r] as Map<String, dynamic>;
        sheet.getRangeByIndex(r + 2, 1).setText((u['id'] ?? u['userId'] ?? '').toString());
        sheet.getRangeByIndex(r + 2, 2).setText((u['name'] ?? '').toString());
        sheet.getRangeByIndex(r + 2, 3).setText((u['email'] ?? '').toString());
        sheet.getRangeByIndex(r + 2, 4).setText((u['role'] ?? '').toString());
      }

      for (int c = 1; c <= headers.length; c++) {
        sheet.autoFitColumn(c);
      }

      final bytes = book.saveAsStream();
      book.dispose();

      final fileName = 'users_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      await _saveFile(bytes, fileName: fileName, ext: 'xlsx', mime: MimeType.microsoftExcel);

      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.success(
          title: "Exported",
          message: "Your Excel file has been saved${kIsWeb ? " (downloaded)" : ""}.",
        ),
      );
    } catch (e, st) {
      debugPrint('XLSX EXPORT ERROR: $e\n$st');
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(
          title: "XLSX Export Failed",
          message: "$e\n\nWe can still export as CSV.",
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _exportSelectedToCsvFallback();
              },
              child: const Text("Export CSV"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _exportSelectedToCsvFallback() async {
    final dataToExport = _dataToExport();
    if (dataToExport.isEmpty) {
      _snack('No users to export');
      return;
    }

    try {
      final buffer = StringBuffer();
      // Header
      buffer.writeln(_csvRow(['ID', 'Name', 'Email', 'Role']));
      // Rows
      for (final raw in dataToExport) {
        final u = raw as Map<String, dynamic>;
        buffer.writeln(_csvRow([
          (u['id'] ?? u['userId'] ?? '').toString(),
          (u['name'] ?? '').toString(),
          (u['email'] ?? '').toString(),
          (u['role'] ?? '').toString(),
        ]));
      }

      final bytes = Uint8List.fromList(utf8.encode(buffer.toString()));
      final fileName = 'users_${DateTime.now().millisecondsSinceEpoch}.csv';

      await _saveFile(bytes, fileName: fileName, ext: 'csv', mime: MimeType.text);

      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.success(
          title: "Exported",
          message: "Your CSV file has been saved${kIsWeb ? " (downloaded)" : ""}.",
        ),
      );
    } catch (e, st) {
      debugPrint('CSV EXPORT ERROR: $e\n$st');
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(
          title: "CSV Export Failed",
          message: e.toString(),
        ),
      );
    }
  }

  List<dynamic> _dataToExport() {
    // Export selected if any; otherwise export all visible non-admins
    final list = _filtered;
    if (selectedIds.isNotEmpty) {
      return list.where((u) => selectedIds.contains((u['id'] ?? u['userId'] ?? 0) as int)).toList();
    }
    return list.where((u) => !_isAdmin(u)).toList();
  }

  String _csvRow(List<String> cols) {
    // Escape CSV fields: wrap in quotes and double any inner quotes
    return cols.map((s) {
      final v = s.replaceAll('"', '""');
      return '"$v"';
    }).join(','); // RFC4180-basic
  }

  Future<void> _saveFile(
    List<int> bytes, {
    required String fileName,
    required String ext,
    required MimeType mime,
  }) async {
    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        ext: ext,
        mimeType: mime,
      );
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    // Opening may fail if no viewer installed; that's fine—file is saved.
    try {
      await OpenFilex.open(file.path);
    } catch (_) {}
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final displayList = _filtered;

    return RefreshIndicator(
      onRefresh: _fetchUsers,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: "Registered Users",
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: "Export",
                    onPressed: displayList.isEmpty ? null : _exportSheet,
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    tooltip: "Refresh",
                    onPressed: _fetchUsers,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            if (error != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: _InlineError(message: error!, onRetry: _fetchUsers),
              ),
            SizedBox(height: 8.h),
            _SearchBar(
              hint: "Search by name, email or role…",
              onChanged: (v) => setState(() => search = v),
            ),
            if (displayList.isEmpty)
              Expanded(
                child: _EmptyState(
                  icon: Icons.people_outline,
                  title: "No users found",
                  subtitle: search.isEmpty
                      ? "Users will appear here once they register."
                      : "Try clearing the search or refreshing.",
                ),
              )
            else
              Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    onChanged: (v) => _toggleSelectAll(v, displayList),
                  ),
                  const Text('Select All (non-admin in view)'),
                  const Spacer(),
                  Text(
                    selectedIds.isEmpty ? 'None selected' : '${selectedIds.length} selected',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            if (displayList.isNotEmpty) SizedBox(height: 8.h),
            if (displayList.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 6.h),
                  itemBuilder: (context, index) {
                    final u = displayList[index];
                    final id = (u['id'] ?? u['userId'] ?? 0) as int;
                    final name = (u['name'] ?? '').toString();
                    final email = (u['email'] ?? '').toString();
                    final role = (u['role'] ?? '').toString();
                    final isAdmin = _isAdmin(u);
                    final isChecked = selectedIds.contains(id);

                    return Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: isAdmin
                            ? const SizedBox(width: 24)
                            : Checkbox(
                                value: isChecked,
                                onChanged: (v) => _toggleOne(id, v),
                              ),
                        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(email),
                        trailing: isAdmin
                            ? const _RoleChip(label: "Admin", color: Colors.grey)
                            : deletingId == id
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                : IconButton(
                                    tooltip: "Delete",
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteUserFlow(id, name.isNotEmpty ? name : email),
                                  ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------- FARES PAGE (NEW) ----------------------------

class _ManageFaresPage extends StatefulWidget {
  const _ManageFaresPage();

  @override
  State<_ManageFaresPage> createState() => _ManageFaresPageState();
}

class _ManageFaresPageState extends State<_ManageFaresPage> {
  final _formKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  String? _service;
  final List<String> _services = const ['Orange', 'Speedo', 'Metro'];

  bool isLoading = true;
  bool isSubmitting = false;
  String? error;
  List<dynamic> fares = [];

  @override
  void initState() {
    super.initState();
    _fetchFares();
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchFares() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await ApiService.getFares();
      setState(() => fares = data);
    } catch (e) {
      setState(() => error = e.toString());
      _snack('Failed to load fares');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveFare() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);
    try {
      final price = int.tryParse(priceController.text.trim()) ?? 0;
      await ApiService.upsertFare(service: _service!, price: price);
      priceController.clear();
      _service = null;

      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.success(
          title: "Fare Saved",
          message: "Fare has been created/updated successfully.",
        ),
      );

      await _fetchFares();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(
          title: "Save Failed",
          message: e.toString(),
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _deleteFare(String service) async {
    try {
      await ApiService.deleteFare(service);
      _snack('Fare deleted');
      await _fetchFares();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) => _NiceDialog.error(title: "Delete failed", message: e.toString()),
      );
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _fetchFares,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Card(
              title: "Set Fare",
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _service,
                      items: _services
                          .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => _service = v),
                      decoration: InputDecoration(
                        labelText: "Service (Orange/Speedo/Metro)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final x = int.tryParse((v ?? '').trim());
                        if (x == null || x <= 0) return 'Enter a valid price (> 0)';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Price (PKR)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isSubmitting ? null : _saveFare,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBrown,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save, color: Colors.white),
                        label: const Text("Save Fare", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _SectionHeader(
              title: "Existing Fares",
              trailing: IconButton(
                tooltip: "Refresh",
                icon: const Icon(Icons.refresh),
                onPressed: _fetchFares,
              ),
            ),
            if (error != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _InlineError(
                  message: error!,
                  onRetry: _fetchFares,
                ),
              ),
            if (fares.isEmpty)
              _EmptyState(
                icon: Icons.attach_money,
                title: "No fares yet",
                subtitle: "Create a fare using the form above.",
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fares.length,
              itemBuilder: (context, index) {
                final f = (fares[index] as Map<String, dynamic>);
                final service = (f['service'] ?? '').toString();
                final price = (f['price'] ?? '').toString();

                return Card(
                  elevation: 1.5,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: darkBrown.withOpacity(0.1),
                      child: const Icon(Icons.monetization_on, color: Colors.black87),
                    ),
                    title: Text(service, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("PKR $price"),
                    trailing: IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFare(service),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------- UI HELPERS ----------------------------

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _LabeledField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: TextFormField(
        controller: controller,
        validator: (v) => v!.trim().isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w, right: 2.w),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800)),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _InlineError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8.w),
          Expanded(child: Text(message, maxLines: 3, overflow: TextOverflow.ellipsis)),
          if (onRetry != null)
            TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: Colors.black26),
            SizedBox(height: 10.h),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 6.h),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final Color color;
  const _RoleChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    );
  }
}

/// ---------------------------- DIALOGS ----------------------------

class _NiceDialog extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final List<Widget>? actions;

  const _NiceDialog._({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    this.actions,
  });

  factory _NiceDialog.success({required String title, required String message, List<Widget>? actions}) =>
      _NiceDialog._(icon: Icons.check_circle, color: Colors.green, title: title, message: message, actions: actions);

  factory _NiceDialog.error({required String title, required String message, List<Widget>? actions}) =>
      _NiceDialog._(icon: Icons.error, color: Colors.red, title: title, message: message, actions: actions);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8.w),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
        ],
      ),
      content: Text(message),
      actions: actions ??
          [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.confirmColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: confirmColor),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
