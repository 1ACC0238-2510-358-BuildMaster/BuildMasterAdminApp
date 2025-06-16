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
import 'login/domain/entities/login.dart';

void main() {
  // Initialize catalogue repository
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
      ],
      child: MaterialApp(
        title: 'Build Master Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LoginFlow(
          baseUrl: 'https://api.example.com/api/auth',
          onAuthenticated: () {
            // Navigate to CataloguePage after successful login
            // Replace with your own routing logic if needed:
            runApp(
              ChangeNotifierProvider.value(
                value: CatalogueProvider(
                  getComponentsUseCase: GetComponentsUseCase(catalogueRepository),
                  getCategoriesUseCase: GetCategoriesUseCase(catalogueRepository),
                  getManufacturersUseCase: GetManufacturersUseCase(catalogueRepository),
                )..loadInitialData(),
                child: MaterialApp(
                  title: 'Build Master Admin',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  ),
                  home: CataloguePage(),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}