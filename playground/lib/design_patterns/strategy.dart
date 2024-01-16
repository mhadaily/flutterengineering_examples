import 'package:flutter/material.dart';

abstract class SortingStrategy {
  List<int> sort(List<int> dataset);
}

class AscendingSort implements SortingStrategy {
  @override
  List<int> sort(List<int> dataset) {
    dataset.sort((a, b) => a.compareTo(b));
    return dataset;
  }
}

class DescendingSort implements SortingStrategy {
  @override
  List<int> sort(List<int> dataset) {
    dataset.sort((b, a) => a.compareTo(b));
    return dataset;
  }
}

class ContextStrategy {
  final SortingStrategy strategy;
  ContextStrategy(this.strategy);

  List<int> executeStrategy(List<int> dataset) {
    return strategy.sort(dataset);
  }
}

class SortingWidget extends StatelessWidget {
  final List<int> dataset;
  final ContextStrategy contextStrategy;

  const SortingWidget({
    super.key,
    required this.dataset,
    required this.contextStrategy,
  });

  @override
  Widget build(BuildContext context) {
    final sortedData = contextStrategy.executeStrategy(dataset);
    return ListView.builder(
      itemCount: sortedData.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(
          sortedData[index].toString(),
        ),
      ),
    );
  }
}

class SortingHome extends StatefulWidget {
  const SortingHome({super.key});

  @override
  SortingHomeState createState() => SortingHomeState();
}

class SortingHomeState extends State<SortingHome> {
  List<int> dataset = [3, 1, 4, 1, 5, 9];
  SortingStrategy currentStrategy = AscendingSort();

  void toggleSortingStrategy() {
    setState(() {
      if (currentStrategy is AscendingSort) {
        currentStrategy = DescendingSort();
      } else {
        currentStrategy = AscendingSort();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Example'),
      ),
      body: SortingWidget(
        dataset: dataset,
        contextStrategy: ContextStrategy(currentStrategy),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleSortingStrategy,
        child: const Icon(Icons.sort),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SortingHome(),
    ),
  ));
}
