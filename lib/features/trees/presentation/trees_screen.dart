import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TreesScreen extends StatefulWidget {
  @override
  _TreesScreenState createState() => _TreesScreenState();
}

class _TreesScreenState extends State<TreesScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _trees = [];
  List<dynamic> _filteredTrees = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTrees(); // Carrega as árvores na inicialização
  }

  Future<void> _fetchTrees() async {
    print('Carregando árvores...');
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('http://192.168.31.98:3000/api/trees'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          _trees = data;
          _filteredTrees = data;
        });
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load trees');
      }
    } catch (e) {
      // Improved error handling
      print('Error fetching trees: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error fetching trees: $e')),
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remova o resizeToAvoidBottomInset ou mantenha como true
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8),
            Text(
              'Nossas Árvores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar árvore...',
                hintStyle:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                fillColor: Theme.of(context).primaryColor, // Cor do fundo
                filled: true,
              ),
              onChanged: (value) {
                // Função para filtrar as árvores com base na pesquisa
                setState(() {
                  _filteredTrees = _trees
                      .where((tree) => tree['name']
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            SizedBox(height: 12),
            _isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio:
                            0.8, // Ajuste este valor se necessário
                      ),
                      itemCount: _filteredTrees.length,
                      itemBuilder: (context, index) {
                        final tree = _filteredTrees[index];
                        return _TreeWidget(tree: tree);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _TreeWidget extends StatelessWidget {
  final dynamic tree;

  const _TreeWidget({Key? key, required this.tree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenha a URL da imagem ou use um placeholder
    final imageUrl = tree['image'] ?? 'https://via.placeholder.com/150';

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/trees/${tree['id']}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Use Expanded para evitar overflow
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                tree['name'],
                style: TextStyle(
                  fontSize: 16, // Ajuste o tamanho da fonte se necessário
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                tree['description'] ?? 'Sem descrição disponível',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2, // Reduza para evitar overflow
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
