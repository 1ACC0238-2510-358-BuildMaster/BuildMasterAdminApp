import 'package:flutter/material.dart';
import '../catalogue/presentation/pages/catalogue_page.dart';
import '../community/presentation/community_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Home dashboard
    _DashboardGrid(),
    // Favoritos (puedes personalizar)
    Center(child: Text('Favoritos', style: TextStyle(fontSize: 24))),
    // Búsqueda
    CataloguePage(categoryId: 0),
    // Configuración
    Center(child: Text('Configuración', style: TextStyle(fontSize: 24))),
    // Comunidad
    CommunityPage(),
    // Precios
    Center(child: Text('Precios', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hola, ¡ADMIN!', style: TextStyle(fontSize: 26)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Página seleccionada
          Positioned.fill(child: _pages[_selectedIndex]),
          // Navbar inferior fijo
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 72,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(0),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.favorite, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(1),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.search, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(2),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.computer, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(3),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.hub, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(4),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.attach_money, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(5),
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

class _DashboardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _DashboardItem(Icons.person, 'Mi Perfil', () {
        // Puedes cambiar a la vista de perfil si lo deseas
      }),
      _DashboardItem(Icons.favorite, 'Favoritos', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(1);
      }),
      _DashboardItem(Icons.search, 'Búsqueda', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(2);
      }),
      _DashboardItem(Icons.computer, 'Configuración', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(3);
      }),
      _DashboardItem(Icons.hub, 'Comunidad', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(4);
      }),
      _DashboardItem(Icons.attach_money, 'Precios', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(5);
      }),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: items.map((item) => item.build(context)).toList(),
      ),
    );
  }
}

class _DashboardItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _DashboardItem(this.icon, this.label, this.onTap);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
