import 'package:flutter/cupertino.dart';
import 'package:corregedoria/pagina_agradecimento.dart';
import 'package:corregedoria/prerrogativas_form.dart';
import 'package:corregedoria/solicitacoes_form.dart';
import 'package:corregedoria/morosidade_form.dart';
import 'package:corregedoria/tema.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: meuTema,
        home: const Home(),
        builder: (context, child) {
          return Material(child: child!);
        },
        routes: {
          '/Morosidade': (context) => const MorosidadeFormScreen(),
          '/Prerrogativas': (context) => const PrerrogativasFormScreen(),
          '/Solicitacoes': (context) => const SolicitacoesFormScreen(),
          '/Agradecimento': (context) => const Agradecimento(),
        }));

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a cor da barra de status
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Color(0xFF002334), // Define a cor desejada para a barra de status
    ));

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle
            .light, // Define o estilo do texto da barra de status
        child: SafeArea(
          child: Container(
            color: Colors.white, // Cor de fundo da tela
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/images/tela_principal.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 75.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Image.asset(
                            'assets/images/oablogo.png',
                            height: 250,
                            width: 250,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Não perca mais tempo em filas ou burocracias! Com nossos serviços da OAB/MS no aplicativo, você resolve tudo em poucos cliques. Acesse já!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PlatformElevatedButton(
                            onPressed: () {
                              // Código para levar o usuário para a próxima tela
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EscolheForm(),
                                ),
                              );
                            },
                            child: const Text('Começar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum EscolheOpcao { morosidade, prerrogativas, solicitacoes }

class EscolheForm extends StatefulWidget {
  final EscolheOpcao? opcao;
  const EscolheForm({Key? key, this.opcao}) : super(key: key);

  @override
  State<EscolheForm> createState() => _EscolheFormState(opcao);
}

class _EscolheFormState extends State<EscolheForm> {
  EscolheOpcao? _opcao;
  _EscolheFormState(EscolheOpcao? opcao) : _opcao = opcao;
  bool _isUrgent = false;
  void abrirWhatsapp(BuildContext context,
      {@required number, @required message}) async {
    final Uri url = Uri.parse("whatsapp://send?phone=$number&text=$message");
    try {
      await launchUrl(url);
    } catch (e) {
      showPlatformDialog(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            title: const Text("Erro"),
            content: const Text(
                "Não foi possível abrir o WhatsApp. Está instalado?"),
            actions: [
              PlatformDialogAction(
                child: PlatformText('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

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
          middle: const Text("Escolha uma opção",
              style: TextStyle(color: Colors.white)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _opcao = EscolheOpcao.morosidade;
                  });
                },
                child: ListTile(
                  title: const Text('Morosidade de Processo'),
                  leading: Radio(
                    value: EscolheOpcao.morosidade,
                    groupValue: _opcao,
                    onChanged: (EscolheOpcao? value) {
                      setState(() {
                        _opcao = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _opcao = EscolheOpcao.prerrogativas;
                  });
                },
                child: ListTile(
                  title: const Text('Prerrogativas'),
                  leading: Radio(
                    value: EscolheOpcao.prerrogativas,
                    groupValue: _opcao,
                    onChanged: (EscolheOpcao? value) {
                      setState(() {
                        _opcao = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _opcao == EscolheOpcao.prerrogativas,
              child: SwitchListTile.adaptive(
                title: const Text('Solicitação urgente?'),
                value: _isUrgent,
                onChanged: (bool? value) {
                  setState(() {
                    _isUrgent = value ?? false;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _opcao = EscolheOpcao.solicitacoes;
                  });
                },
                child: ListTile(
                  title: const Text('Solicitações Diversas'),
                  leading: Radio(
                    value: EscolheOpcao.solicitacoes,
                    groupValue: _opcao,
                    onChanged: (EscolheOpcao? value) {
                      setState(() {
                        _opcao = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            PlatformElevatedButton(
              onPressed: () async {
                if (_opcao != null) {
                  String route = '';
                  switch (_opcao) {
                    case EscolheOpcao.morosidade:
                      route = '/Morosidade';
                      break;
                    case EscolheOpcao.prerrogativas:
                      if (_isUrgent) {
                        abrirWhatsapp(context,
                            number: "+5567981216411",
                            message:
                                "Olá, vim pelo formulário da OAB/MS. Preciso de atendimento.");
                      } else {
                        route = '/Prerrogativas';
                      }
                      break;

                    case EscolheOpcao.solicitacoes:
                      route = '/Solicitacoes';
                      break;
                  }
                  if (route.isNotEmpty) {
                    Navigator.pushNamed(context, route);
                  }
                } else {
                  showPlatformDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PlatformAlertDialog(
                        title: const Text("Erro"),
                        content: const Text("Por favor, selecione uma opção"),
                        actions: [
                          PlatformDialogAction(
                            child: PlatformText('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text("Ir para o formulário"),
            ),
          ],
        ),
      ),
    );
  }
}
