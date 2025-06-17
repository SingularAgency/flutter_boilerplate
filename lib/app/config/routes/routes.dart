import 'route.dart';

/// Class containing all application routes
class Routes {
  // Auth routes
  static const auth = AppRoute(path: '/auth', name: 'auth'); // Unified auth screen (login/signup)
  static const login = AppRoute(path: '/login', name: 'login'); // Alias for auth
  static const register = AppRoute(path: '/register', name: 'register'); // Alias for auth
  static const forgotPassword = AppRoute(path: '/forgot-password', name: 'forgot-password');
  static const resetPassword = AppRoute(path: '/reset-password', name: 'reset-password');

  // Main routes
  static const root = AppRoute(path: '/', name: 'root');
  static const home = AppRoute(path: '/home', name: 'home');
  static const profile = AppRoute(path: '/profile', name: 'profile');
  static const settings = AppRoute(path: '/settings', name: 'settings');

  // Settings routes
  static const notifications = AppRoute(path: '/notifications', name: 'notifications');
  static const privacy = AppRoute(path: '/privacy', name: 'privacy');
  static const help = AppRoute(path: '/help', name: 'help');
  static const about = AppRoute(path: '/about', name: 'about');
} 