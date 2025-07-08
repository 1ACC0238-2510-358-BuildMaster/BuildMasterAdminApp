import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/glosary_api_service.dart';
import '../presentation/glosary_provider.dart';

class GlosaryPage extends StatefulWidget {
  const GlosaryPage({Key? key}) : super(key: key);

  @override
  State<GlosaryPage> createState() => _GlosaryPageState();
}

class _GlosaryPageState extends State<GlosaryPage> {
  String search = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset search when returning to this page
    setState(() {
      search = '';
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlosaryProvider(apiService: GlosaryApiService())..fetchGlosary(),
      child: Consumer<GlosaryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: \\${provider.error}'));
          }
          final filtered = provider.glosarioFacil;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Glosario'),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            backgroundColor: const Color(0xFFF5F5F5),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Buscar término (por palabra)'
                  ),
                  onChanged: (value) {
                    Provider.of<GlosaryProvider>(context, listen: false).filterByPalabra(value);
                    setState(() => search = value);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Términos Clave', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...filtered.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['palabra'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text(item['explicacion'] ?? '', style: const TextStyle(fontSize: 15)),
                        if (item['ejemplo'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text('Ejemplo: ${item['ejemplo']}', style: const TextStyle(color: Colors.green)),
                          ),
                        if (item['tip'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text('Tip: ${item['tip']}', style: const TextStyle(color: Colors.blue)),
                          ),
                        if (item['warning'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text('¡Atención! ${item['warning']}', style: const TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                const Text('Consejos Útiles', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...provider.consejosUtiles.entries.map((entry) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_capitalize(entry.key), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ...entry.value.map((tip) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('• $tip'),
                        )),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
}
