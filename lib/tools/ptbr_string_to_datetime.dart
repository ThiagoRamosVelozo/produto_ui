DateTime ptbrStringToDateTime(String s) {
  List<String> parts = s.split('/');
  return DateTime(
    int.parse(parts[2]),
    int.parse(parts[1]),
    int.parse(parts[0]),
  );
}
