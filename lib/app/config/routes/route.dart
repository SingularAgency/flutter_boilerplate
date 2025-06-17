/// Base class for route definitions
class AppRoute {
  /// The path of the route
  final String path;
  
  /// The name of the route
  final String name;
 
  /// Creates a new route definition
  const AppRoute({
    required this.path,
    required this.name,
  });
} 