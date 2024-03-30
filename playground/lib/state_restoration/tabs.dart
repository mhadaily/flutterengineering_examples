import 'package:flutter/material.dart';

class MyTabView extends StatefulWidget {
  const MyTabView({super.key});

  @override
  _MyTabViewState createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView>
    with RestorationMixin, SingleTickerProviderStateMixin {
  final _selectedIndex = RestorableInt(0);
  TabController? _tabController;

  @override
  String get restorationId => 'tab_view';

  @override
  void restoreState(
      RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(
      _selectedIndex,
      'selected_tab',
    );
    _tabController = TabController(
        vsync: this,
        length: 3,
        initialIndex: _selectedIndex.value);
    _tabController!.addListener(
      () {
        _selectedIndex.value = _tabController!.index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.search)),
          Tab(icon: Icon(Icons.account_circle)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Home')),
          Center(child: Text('Search')),
          Center(child: Text('Profile')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }
}
