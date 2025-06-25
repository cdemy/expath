/// Custom exceptions for Pathfinder operations
class PathfinderException implements Exception {
  final String message;
  final String? path;
  final String? details;
  
  const PathfinderException(this.message, [this.path, this.details]);
  
  @override
  String toString() {
    final pathInfo = path != null ? ' (Path: $path)' : '';
    final detailInfo = details != null ? ' - $details' : '';
    return 'PathfinderException: $message$pathInfo$detailInfo';
  }
}