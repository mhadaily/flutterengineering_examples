import 'package:flutter/material.dart';

abstract interface class MenuItemBase {
  Widget build(BuildContext context);
}

class SimpleMenuItem2 implements MenuItemBase {
  const SimpleMenuItem2({
    required this.title,
    required this.action,
  });

  final Function() action;
  final String title;

  @override
  Widget build(context) {
    return ListTile(title: Text(title), onTap: action);
  }
}

class Submenu2 implements MenuItemBase {
  Submenu2({
    required this.title,
    required this.children,
  });

  final String title;
  final List<MenuItemBase> children;

  @override
  Widget build(context) {
    return ExpansionTile(
      title: Text(title),
      children: children.map((e) => e.build(context)).toList(),
    );
  }
}

class MenuApp2 extends StatelessWidget {
  const MenuApp2({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = Submenu2(
      title: 'File2',
      children: [
        SimpleMenuItem2(
          title: 'New',
          action: () => debugPrint('New file'),
        ),
        SimpleMenuItem2(
          title: 'Open',
          action: () => debugPrint('Open file'),
        ),
        Submenu2(
          title: 'Recent Files',
          children: [
            SimpleMenuItem2(
              title: 'File1.txt',
              action: () => debugPrint('Open File1.txt'),
            ),
            SimpleMenuItem2(
              title: 'File2.png',
              action: () => debugPrint('Open File2.png'),
            ),
          ],
        ),
        SimpleMenuItem2(
          title: 'Exit',
          action: () => debugPrint('Exit'),
        ),
      ],
    );
    return menu.build(context);
  }
}

// Abstract class for all menu items (leaf and composite)
abstract interface class Menuitem implements Widget {
  void expand(bool expanded);
}

// Leaf node
class SimpleMenuItem extends StatelessWidget implements Menuitem {
  const SimpleMenuItem({
    super.key,
    required this.title,
    required this.action,
  });

  final Function() action;
  final String title;

  @override
  void expand(_) {
    // Leaf node, do nothing
  }

  @override
  Widget build(context) {
    return ListTile(title: Text(title), onTap: action);
  }
}

// Composite node that can contain other menu items
class Submenu extends StatefulWidget implements Menuitem {
  Submenu({
    super.key,
    required this.title,
    required this.children,
    this.expandAll = false,
  });

  final String title;
  final bool expandAll;
  final List<Menuitem> children;

  bool childrenExpanded = false;

  @override
  void expand(expanded) {
    childrenExpanded = expanded;
    for (var child in children) {
      child.expand(expanded);
    }
  }

  @override
  SubmenuState createState() => SubmenuState();
}

class SubmenuState extends State<Submenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return ExpansionTile(
      title: Text(widget.title),
      initiallyExpanded: widget.childrenExpanded,
      onExpansionChanged: widget.expandAll ? widget.expand : null,
      children: widget.children,
    );
  }
}

// Usage example
class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SimpleMenuItem(
          title: 'Edit',
          action: () => debugPrint('Edit'),
        ),
        Submenu(
          title: 'File',
          children: [
            SimpleMenuItem(
              title: 'New',
              action: () => debugPrint('New file'),
            ),
            Submenu(
              expandAll: true,
              title: 'Recent Files',
              children: [
                SimpleMenuItem(
                  title: 'File1.txt',
                  action: () => debugPrint('Open File1.txt'),
                ),
                Submenu(
                  title: 'Submenu in submenu',
                  children: [
                    SimpleMenuItem(
                      title: 'New',
                      action: () => debugPrint('New file'),
                    ),
                    Submenu(
                      title: 'Archive',
                      children: [
                        SimpleMenuItem(
                          title: 'file.zip',
                          action: () => debugPrint('file.zip'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: MenuApp(),
      ),
    ),
  );
}
