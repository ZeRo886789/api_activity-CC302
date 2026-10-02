import 'package:flutter/material.dart';

class Fruit {
  String name;
  Fruit({required this.name});
}

class FruitListApp extends StatefulWidget {
  const FruitListApp({super.key});

  @override
  State<FruitListApp> createState() => _FruitListAppState();
}

class _FruitListAppState extends State<FruitListApp> {
  List<Fruit> fruits = [
    Fruit(name: 'Apple'),
    Fruit(name: 'Grape'),
    Fruit(name: 'Orange'),
    Fruit(name: 'Kiwi'),
    Fruit(name: 'Pineapple'),
    Fruit(name: 'Raspberry'),
    Fruit(name: 'Manatad'),
  ];

  void removeFruit(Fruit fruit) {
    setState(() {
      fruits.remove(fruit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Fruit List'), centerTitle: true),
        body: ListView.builder(
          itemCount: fruits.length,
          itemBuilder: (context, index) {
            final fruit = fruits[index];

            return FruitCard(
              fruit: fruit,
              index: index,
              delete: () {
                removeFruit(fruit);
              },
            );
          },
        ),
      ),
    );
  }
}

class FruitCard extends StatelessWidget {
  final Fruit fruit;
  final int index;
  final Function delete;

  const FruitCard({
    super.key,
    required this.fruit,
    required this.index,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(fruit.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 46, 87, 87),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${fruit.name} added to cart!')),
                );
              },
            ),
            TextButton.icon(
              onPressed: () {
                delete();
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}