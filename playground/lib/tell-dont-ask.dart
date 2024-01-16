// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/widgets.dart';

class DataService {
  bool isDataAvailable() {
    // Logic to check if the operation is available
    return true; // Simulated response
  }

  Future<String?> fetchData() async {
    if (isDataAvailable()) {
      return fetchData();
    }
    return null;
  }
}

class AskDataServiceWidget extends StatefulWidget {
  const AskDataServiceWidget({super.key});

  @override
  AskDataServiceWidgetState createState() => AskDataServiceWidgetState();
}

class AskDataServiceWidgetState extends State<AskDataServiceWidget> {
  final DataService service = DataService();
  String data = 'No data yet';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (service.isDataAvailable()) {
      String? fetchedData = await service.fetchData();
      if (fetchedData != null) {
        setState(() {
          data = fetchedData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(data),
    );
  }
}

class TellDataServiceWidget extends StatefulWidget {
  const TellDataServiceWidget({super.key});

  @override
  TellDataServiceWidgetState createState() => TellDataServiceWidgetState();
}

class TellDataServiceWidgetState extends State<TellDataServiceWidget> {
  final DataService service = DataService();
  String data = 'No data yet';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String? fetchedData = await service.fetchData();
    setState(() {
      data = fetchedData ?? 'No data available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(data),
    );
  }
}
