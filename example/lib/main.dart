import 'package:flutter/material.dart';
import 'package:custom_multi_search/custom_multi_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Multi Search Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  late DataSelectionStore<SearchItem> store;

  final List<SearchItem> sampleItems = [
    const SearchItem(id: '1', name: 'Apple', description: 'Red fruit'),
    const SearchItem(id: '2', name: 'Banana', description: 'Yellow fruit'),
    const SearchItem(id: '3', name: 'Cherry', description: 'Small red fruit'),
    const SearchItem(id: '4', name: 'Date', description: 'Sweet fruit'),
    const SearchItem(id: '5', name: 'Elderberry', description: 'Purple berry'),
  ];

  @override
  void initState() {
    super.initState();
    store = DataSelectionStore<SearchItem>(
      items: sampleItems,
      displayProperty: (item) => item.name,
      filterProperty: (item) => item.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Multi Search Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DataSelectionWidget<SearchItem>(
                itemBuilder: null,
                store: store,
                hint: 'Search fruits...',
                labelStr: 'Select Fruits',
                nameExtractor: (item) => item.name,
                onChanged: (selectedItems) {
                 selectedItems.map((e) => e.name).toList();
                },
                isMandatory: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
