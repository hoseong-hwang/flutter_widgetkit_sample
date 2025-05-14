enum EnvironmentType {
  dev(type: "dev", tag: "[DEV]"),
  prod(type: "prod", tag: "");

  final String type;

  final String tag;

  const EnvironmentType({
    required this.type,
    required this.tag,
  });
}
