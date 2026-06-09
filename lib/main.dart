import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar GetMaterialApp habilita a gerência de rotas facilitada do GetX
    return GetMaterialApp(
      title: 'Filmes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Rota inicial apontando para a nossa Dashboard estruturada
      home: const Dashboard(),
    );
  }
}