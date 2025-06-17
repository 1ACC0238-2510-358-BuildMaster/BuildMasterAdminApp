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
import 'catalogue/presentation/pages/build_configuration_page.dart';
import '../dashboard_page.dart';

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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.green,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconColor: Colors.green,
          textColor: Colors.black,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}