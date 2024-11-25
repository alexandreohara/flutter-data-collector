import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';
import 'package:data_collector/database_helper.dart';

class SavedDataScreen extends StatefulWidget {
  @override
  _SavedDataScreenState createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends State<SavedDataScreen> {
  final int pageSize = 10;
  int currentPage = 1;
  bool isLoading = false;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> newItems =
        await DatabaseHelper.instance.queryRowsPaginated(currentPage, pageSize);

    setState(() {
      items.addAll(newItems);
      isLoading = false;
    });
  }

  void _loadNextPage() {
    setState(() {
      currentPage++;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados coletados"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Visibility(
                    visible: !isLoading,
                    child: ElevatedButton(
                      onPressed: _loadNextPage,
                      child: Text("Carregar mais"),
                    ),
                  );
                }

                final item = items[index];
                return ListTile(
                  isThreeLine: true,
                  title: Text(item[DatabaseHelper.name] ?? 'Sem Nome'),
                  subtitle: Text(
                      "${item[DatabaseHelper.number]} \n${item[DatabaseHelper.description]}"),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: EdgeInsets.all(SPACING_16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
