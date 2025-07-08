import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/build_provider.dart';

class SavedBuildsPage extends StatefulWidget {
  const SavedBuildsPage({super.key});

  @override
  State<SavedBuildsPage> createState() => _SavedBuildsPageState();
}

class _SavedBuildsPageState extends State<SavedBuildsPage> {
  late Future<List<String>> _futureBuildIds;
  final Map<String, Map<String, dynamic>> _buildResults = {};

  @override
  void initState() {
    super.initState();
    _loadBuilds();
  }

  void _loadBuilds() {
    final buildProvider = Provider.of<BuildProvider>(context, listen: false);
    _futureBuildIds = buildProvider.getSavedBuildIds();

    // También carga resultados para cada ID
    _futureBuildIds.then((ids) {
      for (var id in ids) {
        buildProvider.fetchBuildDetailAndResult(id).then((data) {
          setState(() {
            _buildResults[id] = data['result'];
          });
        }).catchError((e) {
          debugPrint('Error al cargar resultado de $id: $e');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buildProvider = Provider.of<BuildProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Builds Guardadas'),
      ),
      body: FutureBuilder<List<String>>(
        future: _futureBuildIds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final buildIds = snapshot.data ?? [];

          if (buildIds.isEmpty) {
            return const Center(child: Text('No hay builds guardadas.'));
          }

          return ListView.builder(
            itemCount: buildIds.length,
            itemBuilder: (context, index) {
              final buildId = buildIds[index];
              final buildNumber = index + 1;
              final result = _buildResults[buildId];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text('Build #$buildNumber'),
                  subtitle: result == null
                      ? const Text('Cargando resultado...')
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Performance: ${result['estimatedPerformance']}'),
                      Text('Consumo: ${result['powerConsumptionWatts']} W'),
                      Text('Precio: \$${result['estimatedPrice']}'),
                      Text('Obs: ${result['observations']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await buildProvider.deleteBuild(buildId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Build eliminada')),
                        );
                        setState(() {
                          _loadBuilds();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al eliminar: $e')),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}