import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../catalogue/presentation/pages/build_configuration_page.dart';
import '../community/presentation/community_page.dart';
import '../provider/presentation/pages/provider_screen.dart';
import '../glosary/presentation/glosary_page.dart';
import 'user/presentation/providers/user_provider.dart';

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
    // Búsqueda
    const GlosaryPage(),
    // Configuración
    BuildConfiguratorPage(),
    // Comunidad
    CommunityPage(),
    // Precios
    ProviderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // Redirect to login if not authenticated
    if (userProvider.token == null) {
      Future.microtask(() => Navigator.of(context).pushReplacementNamed('/login'));
      return const SizedBox.shrink();
    }
    String greetingName = '¡ADMIN!';
    if (userProvider.username != null && userProvider.username!.isNotEmpty) {
      greetingName = userProvider.username!;
    } else if (userProvider.email != null && userProvider.email!.isNotEmpty) {
      final email = userProvider.email!;
      greetingName = email.contains('@') ? email.split('@')[0] : email;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $greetingName!', style: const TextStyle(fontSize: 22)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.green),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
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
                    icon: const Icon(Icons.search, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(1),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.computer, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(2),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.hub, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(3),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.attach_money, size: 32, color: Colors.green),
                    onPressed: () => _onItemTapped(4),
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
        Navigator.of(context).pushNamed('/profile');
      }),
      _DashboardItem(Icons.search, 'Búsqueda', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(1);
      }),
      _DashboardItem(Icons.computer, 'Configuración', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(2);
      }),
      _DashboardItem(Icons.hub, 'Comunidad', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(3);
      }),
      _DashboardItem(Icons.attach_money, 'Precios', () {
        final state = context.findAncestorStateOfType<_DashboardPageState>();
        state?._onItemTapped(4);
      }),
    ];

    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.only(bottom: 72), // Deja espacio para la navbar inferior
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: items,
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardItem(this.icon, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.green),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}