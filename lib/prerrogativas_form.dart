import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:corregedoria/EnviaEmail.dart';

class PrerrogativasFormScreen extends StatefulWidget {
  const PrerrogativasFormScreen({Key? key}) : super(key: key);
  @override
  _PrerrogativasFormScreenState createState() =>
      _PrerrogativasFormScreenState();
}

class _PrerrogativasFormScreenState extends State<PrerrogativasFormScreen> {
  // Implemente os campos específicos para a opção "Morosidade de Processo" aqui
  final _nomeController = TextEditingController();
  final _numeroOABController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _numProcessoController = TextEditingController();
  final _relatoController = TextEditingController();

  final _PrerrogativaForm = GlobalKey<FormState>();

  List<PlatformFile> _selectedFile = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(PlatformIcons(context).back),
            ),
            backgroundColor: Color(0xFF00679E),
            middle: const Text("Prerrogativas",
                style: TextStyle(color: Colors.white)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _PrerrogativaForm,
              child: ListView(
                children: [
                  // Adicione os campos do formulário para a opção "Prerrogativas" aqui
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome completo",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numeroOABController,
                    decoration: const InputDecoration(
                      labelText: "Nº OAB",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (!value.contains('@')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Telefone Celular",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numProcessoController,
                    decoration: const InputDecoration(
                      labelText: "Número do processo/inquérito",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _relatoController,
                    decoration: const InputDecoration(
                      labelText: "Breve relato",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedFile.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _selectedFile.length,
                      itemBuilder: (context, index) {
                        final file = _selectedFile[index];
                        return ListTile(
                          leading: Icon(Icons.insert_drive_file),
                          title: Text(file.name),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                  PlatformElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowMultiple: true,
                        allowedExtensions: [
                          'jpg',
                          'jpeg',
                          'pdf',
                          'mp3',
                          'mp4',
                          'png'
                        ],
                      );
                      if (result == null) return;
                      List<File> filesToDelete = [];
                      for (var file in result.files) {
                        // Verificar o tamanho do arquivo
                        if (file.size > 10 * 1024 * 1024) {
                          showPlatformDialog(
                            context: context,
                            builder: (_) => PlatformAlertDialog(
                              title: Text("Erro"),
                              content: Text(
                                  "O arquivo ${file.name} excede o tamanho máximo permitido (10 MB)."),
                              actions: [
                                PlatformDialogAction(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                          filesToDelete.add(File(file.path!));
                        }
                      }
                      for (var fileToDelete in filesToDelete) {
                        fileToDelete.delete();
                      }
                      setState(() {
                        _selectedFile.addAll(result.files);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(PlatformIcons(context).folderOpen), // Ícone
                        SizedBox(
                            width: 8), // Espaçamento entre o ícone e o texto
                        Text('Escolher arquivos'), // Texto
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlatformElevatedButton(
                    onPressed: () {
                      if (_PrerrogativaForm.currentState!.validate()) {
                        String solicitacao = 'Corregedoria Aplicativo';
                        String assunto =
                            'Novo formulário de Prerrogativas preenchido.';
                        String conteudo = '''
                        Nome: ${_nomeController.text}
                        Nº OAB: ${_numeroOABController.text}
                        E-mail: ${_emailController.text}
                        Telefone Celular: ${_phoneController.text}
                        Número do processo/inquérito: ${_numProcessoController.text}
                        Breve relato: ${_relatoController.text}
                      ''';
                        String conteudoHTML = '''
                        <h1>Corregedoria Geral OAB/MS</h1>
                        <h2>Novo formulário de Prerrogativas preenchido</h2>
                        <p><b>Nome:</b> ${_nomeController.text}</p>
                        <p><b>Nº OAB:</b> ${_numeroOABController.text}</p>
                        <p><b>E-mail:</b> ${_emailController.text}</p>
                        <p><b>Telefone Celular:</b> ${_phoneController.text}</p>
                        <p><b>Número do processo/inquérito:</b> ${_numProcessoController.text}</p>
                        <p><b>Breve relato:</b> ${_relatoController.text}</p>
                      ''';
                        // Chamada de função para envio do e-mail para a Corregedoria
                        enviarEmail(solicitacao, assunto, conteudo,
                            conteudoHTML, _selectedFile);
                        // Chamada da função de envio do e-mail de agradecimento
                        enviarEmailDeAgradecimento(_emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Solicitação enviada!')),
                        );
                        Navigator.pushNamed(context, '/Agradecimento');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(PlatformIcons(context).rightChevron), // Ícone
                        SizedBox(
                            width: 8), // Espaçamento entre o ícone e o texto
                        Text('Enviar solicitação'), // Texto
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
