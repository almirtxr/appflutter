import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mime/mime.dart';

void enviarEmail(String assunto, String conteudo, String solicitacao,
    String conteudoHTML, List<PlatformFile> arquivosSelecionados) async {
  final smtpServer =
    SmtpServer('smtplw.com.br', username: 'oabms', password: 'XqkJJyKS4692');

  final message = Message()
    ..from = const Address(
        'tecnologia_informacao@oabms.org.br', 'Aplicativo Corregedoria OAB/MS')
    ..recipients.add('almirgabriel@oabms.org.br')
    // ..recipients.add('corregedoria@oabms.org.br')
    ..subject = assunto
    ..text = conteudo
    ..html = conteudoHTML;

  if (arquivosSelecionados == true && arquivosSelecionados.isNotEmpty) {
    for (var arquivo in arquivosSelecionados) {
      final file = File(arquivo.path!);
      final filename = arquivo.name;
      final mediaType = lookupMimeType(file.path);

      final attachment = FileAttachment(file);
      attachment.fileName = filename;
      attachment.contentType = mediaType.toString();
      message.attachments.add(attachment);
    }
  }

  try {
    await send(message, smtpServer);
  } catch (e) {
    print('Erro ao enviar e-mail: $e');
  }
}

//Essa função é usada para enviar e-mail ao usuário

void enviarEmailDeAgradecimento(String emailUsuario) async {
  final smtpServer =
      SmtpServer('smtplw.com.br', username: 'oabms', password: 'XqkJJyKS4692');

  final message = Message()
    ..from = const Address(
        'tecnologia_informacao@oabms.org.br', 'Aplicativo Corregedoria OAB/MS')
    ..recipients.add(emailUsuario) // Usar o e-mail fornecido pelo usuário
    ..subject = 'Agradecimento pelo preenchimento do formulário'
    ..html = '''
        <h1>Corregedoria Geral OAB/MS</h1>
        <p>
        Agradecemos pelo seu interesse e solicitação. Estamos avaliando cuidadosamente
        todas as informações fornecidas e entraremos em contato em breve para fornecer uma
        atualização sobre a situação da sua solicitação. Caso haja necessidade
        de mais informações, entraremos em contato para solicitar os detalhes
        adicionais. Agradecemos novamente pelo seu interesse e aguardamos para fornecer
        mais informações me breve.
        Em caso de dúvida ou informações complementares.
        Entre em contato por WhatsApp: <a href="wa.me/+556798861012"> 67 988611012 </a>.
        </p>
    ''';

  try {
    await send(message, smtpServer);
  } catch (e) {
    print('Erro ao enviar e-mail de agradecimento: $e');
  }
}
