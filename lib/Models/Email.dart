import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Email {
  String _content;
  String _subject;

  String get content => _content;

  void set content(String content) {
    _content = content;
  }

  Email(this._content, this._subject);

  Future<bool> sendMessage() async {
    String username = 'auza920205';
    String password = 'auza23364773';

    final smtpServer = gmail(username, password);

    String mailAddress = 'jano-2709@hotmail.com';

    final message = Message()
    ..from = Address(username, 'Alex Aguilar')
    ..recipients.add(mailAddress)
    //..ccRecipients.addAll(['rgp25@hotmail.com'])
    ..subject = _subject
    ..text = 'Sistema de venta Tiburón.\nCliente: .'
    ..html = _content;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }

}