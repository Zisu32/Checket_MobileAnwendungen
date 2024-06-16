enum Status { verfuegbar, abgeholt, verloren }

class Jacket {
  final int jacketNumber;
  late Status status;
  final String imagePath;
  final String qrString;

  Jacket({
    required this.jacketNumber,
    required this.status,
    required this.imagePath,
    required this.qrString,
  });
}
