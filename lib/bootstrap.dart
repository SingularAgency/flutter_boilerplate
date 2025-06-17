import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/app/core/common/providers/locale_provider.dart';
import 'package:flutter_boilerplate/app/core/common/providers/router_provider.dart';
import 'package:flutter_boilerplate/app/core/common/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_boilerplate/app/core/common/providers/router_provider.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';


// Global reference for providers
late final ProviderContainer globalRef;

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Consumer(
          builder: (context, ref, child) {
            final themeData = ref.watch(themeDataProvider);
            final themeMode = ref.watch(themeModeProvider);
            return MaterialApp.router(
              routerConfig: ref.watch(routerProvider),
              theme: themeData,
              themeMode: themeMode,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: ref.watch(localeProvider),
              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.01);
                final l10n = context.l10n;
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                );
              },
            );
          },
        ),
      );
  }
}

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    log('Provider updated: ${provider.name ?? provider.runtimeType}');
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize error handling
    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    };

    // Initialize Hive
    await Hive.initFlutter();
    
    // Create app with ProviderScope
    final widget = await builder();
    final app = ProviderScope(
      observers: [ProviderLogger()],
      child: widget,
    );

    runApp(app);
  }, (error, stack) {
    log('Uncaught error: $error');
    log('Stack trace: $stack');
  });
}
