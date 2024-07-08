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

String getIpAddress()
{
  //final String ip = "192.168.178.56";
  //final String ip = "192.168.0.211";
  final String ip = "192.168.56.1";
  //final String ip = "10.0.2.2";
  return ip;
}