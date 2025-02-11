import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FileManagerController controller = FileManagerController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => (await controller.goToParentDirectory()),
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => controller.setCurrentStorage(storageIndex: 1),
                icon: Icon(Icons.sd_storage_rounded),
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                await controller.goToParentDirectory();
              },
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            child: FileManager(
              controller: controller,
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: isFile(snapshot[index])
                            ? Icon(Icons.feed_outlined)
                            : Icon(Icons.folder),
                        title: Text(basename(snapshot[index])),
                        onTap: () {
                          if (isDirectory(snapshot[index]))
                            controller.openDirectory(snapshot[index]);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )),
    );
  }
}
