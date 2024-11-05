DateTime stringToDateTime(String s) {
  List<String> parts = s.split('-');
  return DateTime(int.parse(parts[0]), int.parse(parts[1]),
      int.parse(parts[2].split('T')[0]));
}
