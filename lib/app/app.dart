import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../features/template/index.dart';
import '../l10n/gen/app_localizations.dart';
import '../theme/index.dart';
import 'index.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TemplateRepository>(create: (_) => TemplateRepository()),
        // <add more repo here> -- DO NOT DELETE/MODIFY THIS COMMENT IT'S A MARKER FOR BASH SCRIPT
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              themeBlocProvider(AppTheme.system),
              // add more global bloc here -- DO NOT DELETE/MODIFY THIS COMMENT IT'S A MARKER FOR BASH SCRIPT
            ],
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final brightness = state.appTheme.brightness(context);
                return MaterialApp.router(
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(
                      brightness: brightness,
                      seedColor: const Color(0xff4B39EF),
                    ),
                    brightness: brightness,
                    textTheme: GoogleFonts.poppinsTextTheme(),
                    primaryTextTheme: GoogleFonts.poppinsTextTheme(),
                  ),
                  title: "flapper",
                  locale: const Locale('en'), // can be dynamically controlled to switch language within the app
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
