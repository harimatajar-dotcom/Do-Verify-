import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/template_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/templates_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/checklist_detail_screen.dart';
import 'presentation/screens/create_screen.dart';
import 'presentation/screens/shared_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/notifications_screen.dart';
import 'data/repositories/template_repository_impl.dart';
import 'data/datasources/template_local_datasource.dart';
import 'data/datasources/template_remote_datasource.dart';
import 'core/network/api_client.dart';
import 'domain/usecases/get_all_templates_usecase.dart';
import 'domain/usecases/get_featured_templates_usecase.dart';
import 'domain/usecases/get_template_by_id_usecase.dart';
import 'domain/usecases/search_templates_usecase.dart';
import 'domain/usecases/filter_templates_by_category_usecase.dart';
import 'domain/entities/checklist_entity.dart';

/// Main CheckFlow application widget
class CheckFlowApp extends StatelessWidget {
  const CheckFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        // Template Provider with dependencies
        ChangeNotifierProvider(
          create: (_) {
            // Create data sources
            final localDataSource = TemplateLocalDataSource();
            final apiClient = ApiClient();
            final remoteDataSource = TemplateRemoteDataSource(apiClient);

            // Create repository
            final repository = TemplateRepositoryImpl(
              localDataSource: localDataSource,
              remoteDataSource: remoteDataSource,
            );

            // Create use cases
            final getAllTemplatesUseCase = GetAllTemplatesUseCase(repository);
            final getFeaturedTemplatesUseCase = GetFeaturedTemplatesUseCase(repository);
            final getTemplateByIdUseCase = GetTemplateByIdUseCase(repository);
            final searchTemplatesUseCase = SearchTemplatesUseCase(repository);
            final filterTemplatesByCategoryUseCase = FilterTemplatesByCategoryUseCase(repository);

            // Create and return provider
            return TemplateProvider(
              getAllTemplatesUseCase: getAllTemplatesUseCase,
              getFeaturedTemplatesUseCase: getFeaturedTemplatesUseCase,
              getTemplateByIdUseCase: getTemplateByIdUseCase,
              searchTemplatesUseCase: searchTemplatesUseCase,
              filterTemplatesByCategoryUseCase: filterTemplatesByCategoryUseCase,
            );
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CheckFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/main',
            onGenerateRoute: _generateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainShell(),
          settings: settings,
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case '/templates':
        return MaterialPageRoute(
          builder: (_) => const TemplatesScreen(),
          settings: settings,
        );

      case '/checklist':
        final checklist = settings.arguments as ChecklistEntity?;
        return MaterialPageRoute(
          builder: (_) => ChecklistDetailScreen(checklist: checklist),
          settings: settings,
        );

      case '/create':
        return MaterialPageRoute(
          builder: (_) => const CreateScreen(),
          settings: settings,
        );

      case '/shared':
        return MaterialPageRoute(
          builder: (_) => const SharedScreen(),
          settings: settings,
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
    }
  }
}
