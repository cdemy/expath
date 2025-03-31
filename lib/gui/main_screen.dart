import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regex File Extractor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Neu")),
                SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: Text("Ordner hinzufügen")),
                SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: Text("Vorschau")),
                SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: Text("Excel-Datei generieren")),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) => ListTile(
                          title: Text("Datensatz ${index + 1}"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text("Hinzufügen")),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: Text("Entfernen")),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: Text("Speichern")),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: Text("Laden")),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) => ListTile(
                          title: Text("Regel ${index + 1}"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
