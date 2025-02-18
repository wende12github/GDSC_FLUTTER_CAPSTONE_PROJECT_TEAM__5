import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:e_commerce_app/auth/bloc/auth_bloc.dart';
import 'package:e_commerce_app/auth/repositories/auth_repo.dart';
import 'package:e_commerce_app/controllers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:e_commerce_app/controllers/theme_provider/theme_provider.dart';
import 'package:e_commerce_app/product/bloc/product_bloc.dart';
import 'package:e_commerce_app/product/repo/product_repo.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/user/bloc/user_bloc.dart';
import 'package:e_commerce_app/user/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Chapa.configure(privateKey: "CHASECK_TEST-S6Y7XQhsRMWfHvykP7vbSRdX9067HMPQ");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(repo: AuthRepo()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepo: ProductRepo()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepo: UserRepo(),productRepo: ProductRepo()),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Provider.of<ThemeProvider>(context).themeData,
        initialRoute: RouteClass.getAuthRoute(),
        getPages: RouteClass.routes,
      ),
    );
  }
}
