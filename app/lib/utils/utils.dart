import '../models/jacketModel.dart';

String mapStatusToString(Status newStatus) {
  switch (newStatus) {
    case Status.verfuegbar:
      return "verfuegbar";
    case Status.abgeholt:
      return "abgeholt";
    case Status.verloren:
      return "verloren";
    default:
      return "verfuegbar";
  }
}