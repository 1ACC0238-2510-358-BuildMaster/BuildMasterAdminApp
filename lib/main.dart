import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'catalogue/data/datasources/component_api_service.dart';
import 'catalogue/data/datasources/category_api_service.dart';
import 'catalogue/data/datasources/manufacturer_api_service.dart';
import 'catalogue/data/repositories/catalogue_repository_impl.dart';
import 'catalogue/domain/usecases/get_components.dart';
import 'catalogue/domain/usecases/get_categories.dart';
import 'catalogue/domain/usecases/get_manufacturers.dart';
import 'catalogue/presentation/pages/catalogue_page.dart';
import 'catalogue/presentation/providers/catalogue_provider.dart';

void main() {
  final catalogueRepository = CatalogueRepositoryImpl(
    componentService: ComponentApiService(),
    categoryService: CategoryApiService(),
    manufacturerService: ManufacturerApiService(),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CatalogueProvider(
        getComponentsUseCase: GetComponentsUseCase(catalogueRepository),
        getCategoriesUseCase: GetCategoriesUseCase(catalogueRepository),
        getManufacturersUseCase: GetManufacturersUseCase(catalogueRepository),
      )..loadInitialData(),
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
      home: const CataloguePage(),
    );
  }
}