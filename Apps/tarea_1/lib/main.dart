import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Color colorTexto = Colors.red;
  String textoDummy = "Data";
  double sizeTexto = 20;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                textoDummy,
                style: TextStyle(color: colorTexto, fontSize: sizeTexto),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          if (sizeTexto < 30) sizeTexto += 5;
                        });
                      },
                      child: const Text("+")),
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          if (sizeTexto > 10) sizeTexto -= 5;
                        });
                      },
                      child: const Text("-"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        colorTexto = Colors.red;
                      });
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(100, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text("Rojo"),
                  ),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        colorTexto = Colors.blue;
                      });
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(100, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text("Azul"),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    textoDummy = "";
                  });
                },
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: const Size(200, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: const Text("Borrar"),
              ),
              FilledButton(
                  onPressed: () {
                    setState(() {
                      textoDummy = "Presiona el boton para borrar";
                    });
                  },
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: const Size(200, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text("Restaurar"))
            ],
          ),
        ),
      ),
    );
  }
}
