import 'package:flutter/material.dart';
import 'package:shared_pref/src/services/shared_pref_service.dart';
import 'package:shared_pref/src/ui/pages/hive_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HiveTest(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> gecmisLoglar = [];
  late final controller = TextEditingController();

  late final prefService = SharedPrefsService();

  var testVerisi = '';

  @override
  void initState() {
    super.initState();
    SharedPrefsService.initService().then((value) {
      gecmisLoglar.add(value
          ? 'SharedPrefsService Basariyla devreye alindi'
          : 'SharedPrefsService hatali su anda');

      testVerisi = prefService.getString('test') ?? 'BOS SUAN';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: gecmisLoglar.map((e) => Text(e)).toList()),
            const SizedBox(
              height: 100,
            ),
            Text('TEST DATA VERISI => $testVerisi'),
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                  Flexible(
                      child: TextButton(
                          onPressed: () {
                            prefService
                                .setString('test', controller.text)
                                .then((value) {
                              gecmisLoglar.add(value
                                  ? 'test keyi adi altina ${controller.text} eklendi'
                                  : 'Hata');
                              setState(() {});
                            });
                          },
                          // onPressed: () async {
                          //   final result = await prefService.setString(
                          //       'test', controller.text);
                          //   gecmisLoglar.add(result
                          //       ? 'test keyi adi altina ${controller.text} eklendi'
                          //       : 'Hata');
                          //   setState(() {});
                          // },
                          child: const Text('ekle')))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
