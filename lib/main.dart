import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:safqah_assessment/features/expenses_list/presentation/providers/expenses_list_provider.dart';
import 'core/di/app_di.dart' as app_di;
import 'features/expenses_list/presentation/pages/expenses_list_screen.dart';

void main() async {
  // Init application DI using get_it
  await app_di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<ExpensesListProvider>(),
        ),
      ],
      child: ScreenUtilInit(
        builder: (_, w) => const MaterialApp(
          title: 'Expenses App',
          home: ExpensesListScreen(),
        ),
      ),
    );
  }
}
