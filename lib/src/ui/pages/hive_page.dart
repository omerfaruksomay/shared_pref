import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_pref/src/models/person_model.dart';
import 'package:shared_pref/src/services/hive_service.dart';

class HiveTest extends StatefulWidget {
  const HiveTest({super.key});

  @override
  State<HiveTest> createState() => _HiveTestState();
}

class _HiveTestState extends State<HiveTest> {
  final formKey = GlobalKey<FormState>();

  late final Box<PersonModel> personBox;
  bool boxLoaded = false;

  PersonModel person = PersonModel.empty();

  initLocalDb() async {
    final result = await HiveService.initService();
    personBox = await HiveService.openBox<PersonModel>('person');
    setState(() {
      boxLoaded = true;
    });
    print(result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initLocalDb();
    // Future.microtask(() async {
    //   final result = await HiveService.initService();
    //   print(result);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) => person.name = value,
                    validator: (value) =>
                        (value?.length ?? 0) < 2 ? 'İsmin 2 harf olanaz' : null,
                  ),
                  TextFormField(
                    onChanged: (value) =>
                        person.age = (int.tryParse(value) ?? 0),
                    validator: (value) => (int.tryParse(value ?? '0') ?? 0) < 18
                        ? 'yanlış değer girdiniz.'
                        : null,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await HiveService.writeToBox(personBox, person);
                        person = PersonModel.empty();
                      }
                    },
                    child: const Text('send'),
                  ),
                ],
              ),
            ),
            if (boxLoaded)
              ValueListenableBuilder(
                valueListenable: personBox.listenable(),
                builder: (context, value, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: personBox.values.length,
                    itemBuilder: (context, index) {
                      final element = personBox.values.elementAt(index);
                      return ListTile(
                        title: Text(element.name),
                        subtitle: Text(
                          element.age.toString(),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              HiveService.remove(personBox, index);
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
