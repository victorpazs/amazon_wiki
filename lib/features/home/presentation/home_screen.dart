// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:amazon_wiki_app/core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Avatar com o logo
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: ClipOval(
                child: Image.network(
                  'https://i.ibb.co/Rhsj3gQ/logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.red, size: 80);
                  },
                ),
              ),
            ),
            SizedBox(height: 20), // Espaço entre o avatar e o texto
            // Texto "Bem-vindo"
            Column(
              children: const [
                Text(
                  'Bem-vindo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'AmazonWiki',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // Cor do texto "AmazonWiki"
                  ),
                ),
              ],
            ),
            SizedBox(height: 40), // Espaço entre o texto e o botão
            // Botão com o estilo desejado
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.trees);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Acessar',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300)),
            ),
          ],
        ),
      ),
    );
  }
}
