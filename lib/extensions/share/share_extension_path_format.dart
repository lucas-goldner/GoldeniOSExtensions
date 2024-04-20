enum ShareExtensionPathParameters {
  url("url"),
  description("description");

  const ShareExtensionPathParameters(this.name);

  final String name;

  String get nameWithEqualSign => "$name=";
}

bool isSharedExtensionPath(String path) {
  return path.contains(ShareExtensionPathParameters.url.name) &&
      path.contains(ShareExtensionPathParameters.url.name);
}

(String, String) extractSharedExtensionData(String path) {
  // example: /url=https://lol.com/thing/parameter/&description=lol

  final url = path.substring(
    ShareExtensionPathParameters.url.nameWithEqualSign.length + 1,
    path.indexOf("&${ShareExtensionPathParameters.description.name}"),
  );
  final description = path.substring(
    path.indexOf("&${ShareExtensionPathParameters.description.name}") +
        ShareExtensionPathParameters.description.nameWithEqualSign.length +
        1,
    path.length,
  );

  return (url, description);
}
