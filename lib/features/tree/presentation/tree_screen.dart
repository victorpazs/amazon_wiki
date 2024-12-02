import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TreeDetailScreen extends StatefulWidget {
  final int treeId;

  const TreeDetailScreen({Key? key, required this.treeId}) : super(key: key);

  @override
  _TreeDetailScreenState createState() => _TreeDetailScreenState();
}

class _TreeDetailScreenState extends State<TreeDetailScreen> {
  Map<String, dynamic>? tree;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTree();
  }

  Future<void> _fetchTree() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('http://192.168.31.98:3000/api/trees/${widget.treeId}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          tree = data;
        });
      } else {
        throw Exception('Failed to load tree');
      }
    } catch (e) {
      print('Error fetching tree: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final Map<String, String> fieldLabels = {
    'description': 'Descrição',
    'fruiting': 'Frutificação',
    'dispersion': 'Dispersão',
    'nutrition': 'Nutrição',
    'food_source': 'Fonte Alimentar',
    'bioactivity': 'Bioatividade',
    'landscaping': 'Paisagismo',
    'cultive': 'Cultivo',
  };

  final List<String> expansionFields = ['fruiting', 'dispersion'];

  @override
  Widget build(BuildContext context) {
    final imageUrl = tree != null
        ? tree!['image'] ?? 'https://via.placeholder.com/150'
        : 'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : tree == null
              ? Center(child: Text('Erro ao carregar árvore'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://via.placeholder.com/70',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        tree!['name'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(36.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: () {
                            List<Widget> items = [];

                            for (var field in fieldLabels.keys) {
                              if (tree![field] != null &&
                                  (tree![field] as String).isNotEmpty) {
                                if (expansionFields.contains(field)) {
                                  items.add(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.zero,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        collapsedBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        title: Text(
                                          fieldLabels[field] ?? '',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16.0),
                                            color: Colors.white,
                                            child: Text(
                                              tree![field],
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  items.add(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${fieldLabels[field]}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            tree![field],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            }

                            return items;
                          }(),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
