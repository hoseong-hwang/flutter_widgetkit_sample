enum EnviromentType {
  dev(type: "dev", tag: "[DEV]"),
  prod(type: "prod", tag: "");

  final String type;

  final String tag;

  const EnviromentType({
    required this.type,
    required this.tag,
  });
}
