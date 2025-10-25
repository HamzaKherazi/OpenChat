String getChatId(String email1, String email2) {
  final sorted = [email1, email2]..sort();
  return sorted.join("_");
}
