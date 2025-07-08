import 'package:build_master_adminapp/catalogue/presentation/pages/admin_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'catalogue/data/datasources/component_api_service.dart';
import 'catalogue/data/datasources/category_api_service.dart';
import 'catalogue/data/datasources/manufacturer_api_service.dart';
import 'catalogue/data/datasources/build_api_service.dart';
import 'catalogue/data/repositories/catalogue_repository_impl.dart';
import 'catalogue/domain/usecases/get_components.dart';
import 'catalogue/domain/usecases/get_categories.dart';
import 'catalogue/domain/usecases/get_manufacturers.dart';
import 'catalogue/presentation/providers/catalogue_provider.dart';
import 'catalogue/presentation/providers/build_provider.dart';
import 'catalogue/presentation/pages/manage_categories_page.dart';
import 'catalogue/presentation/pages/manage_components_page.dart';
import 'catalogue/presentation/pages/manage_manufacturers_page.dart';
import 'catalogue/domain/usecases/create_component.dart';
import 'catalogue/domain/usecases/create_manufacturer.dart';
import 'catalogue/domain/usecases/delete_component.dart';
import 'catalogue/domain/usecases/delete_manufacturer.dart';
import 'catalogue/domain/usecases/update_component.dart';
import 'dashboard_page.dart';
import 'user/presentation/pages/user_login_page.dart';
import 'user/presentation/pages/user_register_page.dart';
import 'user/presentation/pages/user_profile_page.dart';
import 'user/presentation/providers/user_provider.dart';
import 'root_page.dart';
import 'community/presentation/providers/community_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Limpia los builds guardados al iniciar la app
  //final prefs = await SharedPreferences.getInstance();
  //await prefs.remove('saved_builds');
  final catalogueRepository = CatalogueRepositoryImpl(
    componentService: ComponentApiService(),
    categoryService: CategoryApiService(),
    manufacturerService: ManufacturerApiService(),
  );
  final buildApiService = BuildApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CommunityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogueProvider(
              getComponentsUseCase: GetComponentsUseCase(catalogueRepository),
              getCategoriesUseCase: GetCategoriesUseCase(catalogueRepository),
              getManufacturersUseCase: GetManufacturersUseCase(catalogueRepository),
              createManufacturerUseCase: CreateManufacturerUseCase(catalogueRepository),
              deleteManufacturerUseCase: DeleteManufacturerUseCase(catalogueRepository),
              createComponentUseCase: CreateComponentUseCase(catalogueRepository),
              deleteComponentUseCase: DeleteComponentUseCase(catalogueRepository),
              updateComponentUseCase: UpdateComponentUseCase(catalogueRepository)
          )..loadInitialData(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuildProvider(apiService: buildApiService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const RootPage(),
        '/admin': (context) => const AdminPanelPage(),
        '/admin/categories': (context) => const ManageCategoriesPage(),
        '/admin/manufacturers': (context) => const ManageManufacturersPage(),
        '/admin/components': (context) => const ManageComponentsPage(),
        '/login': (context) => const UserLoginPage(),
        '/register': (context) => const UserRegisterPage(),
        '/profile': (context) => const UserProfilePage(),
      },
    );
  }
}