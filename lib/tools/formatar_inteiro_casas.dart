String formatarInteiroCasas(int inteiro, int casas) {
  String inteiroString = inteiro.toString();
  return '0' * (casas - inteiroString.length) + inteiroString;
}
