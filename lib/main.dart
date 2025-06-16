import 'package:build_master_adminapp/catalogue/presentation/pages/build_configuration_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'catalogue/data/datasources/component_api_service.dart';
import 'catalogue/data/datasources/category_api_service.dart';
import 'catalogue/data/datasources/manufacturer_api_service.dart';
import 'catalogue/data/repositories/catalogue_repository_impl.dart';
import 'catalogue/domain/usecases/get_components.dart';
import 'catalogue/domain/usecases/get_categories.dart';
import 'catalogue/domain/usecases/get_manufacturers.dart';
import 'catalogue/presentation/providers/catalogue_provider.dart';
import 'catalogue/presentation/providers/build_provider.dart';

void main() {
  final catalogueRepository = CatalogueRepositoryImpl(
    componentService: ComponentApiService(),
    categoryService: CategoryApiService(),
    manufacturerService: ManufacturerApiService(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CatalogueProvider(
            getComponentsUseCase: GetComponentsUseCase(catalogueRepository),
            getCategoriesUseCase: GetCategoriesUseCase(catalogueRepository),
            getManufacturersUseCase: GetManufacturersUseCase(catalogueRepository),
          )..loadInitialData(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuildProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build Master Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BuildConfiguratorPage(),
    );
  }
}