import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

/// Router configuration for the application
class AppRouter {
  /// Creates the router configuration
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: Routes.login.path,
      debugLogDiagnostics: true,
      routes: [
        // Auth routes
        GoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          builder: (context, state) => const AuthScreen(initialTab: 0), // Login tab
        ),
        GoRoute(
          path: Routes.register.path,
          name: Routes.register.name,
          builder: (context, state) => const AuthScreen(initialTab: 1), // Sign Up tab
        ),
        GoRoute(
          path: Routes.forgotPassword.path,
          name: Routes.forgotPassword.name,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: Routes.resetPassword.path,
          name: Routes.resetPassword.name,
          builder: (context, state) => const ResetPasswordScreen(),
        ),

        // Main app route (with bottom navigation)
        GoRoute(
          path: Routes.root.path,
          name: Routes.root.name,
          builder: (context, state) => const MainScreen(),
        ),

        // Profile routes
        GoRoute(
          path: Routes.profile.path,
          name: Routes.profile.name,
          builder: (context, state) => const ProfileScreen(),
        ),

        // Settings routes
        GoRoute(
          path: Routes.settings.path,
          name: Routes.settings.name,
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'notifications',
              name: Routes.notifications.name,
              builder: (context, state) => const NotificationsScreen(),
            ),
            GoRoute(
              path: 'privacy',
              name: Routes.privacy.name,
              builder: (context, state) => const PrivacyScreen(),
            ),
            GoRoute(
              path: 'help',
              name: Routes.help.name,
              builder: (context, state) => const HelpScreen(),
            ),
            GoRoute(
              path: 'about',
              name: Routes.about.name,
              builder: (context, state) => const AboutScreen(),
            ),
          ],
        ),

        // Error route
        GoRoute(
          path: '/error',
          name: 'error',
          builder: (context, state) => ErrorScreen(error: state.error),
        ),
      ],
      errorBuilder: (context, state) => ErrorScreen(error: state.error),
    );
  }
}

/// Placeholder screens - Replace with actual implementations
class AuthScreen extends StatelessWidget {
  final int initialTab;

  const AuthScreen({super.key, required this.initialTab});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Auth Screen')),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Forgot Password Screen')),
    );
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Reset Password Screen')),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Main Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Screen')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Notifications Screen')),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Privacy Screen')),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Help Screen')),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('About Screen')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('An error occurred'),
            if (error != null) Text(error.toString()),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
} 