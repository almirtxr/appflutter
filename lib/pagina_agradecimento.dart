
import 'package:flutter/material.dart';



class Agradecimento extends StatelessWidget {
  const Agradecimento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/mailcheck.png',
              fit: BoxFit.cover,
              width: 100, // Largura desejada
              height: 100, // Altura desejada
          ),
        ),
          const SizedBox(height: 16), // Espaço entre a imagem e o texto
          const Text(
            'Obrigado pelo envio!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
