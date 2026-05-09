import 'package:flutter/material.dart';

class WidgetsDemoPage extends StatelessWidget {
  const WidgetsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Layout Sederhana'),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              context,
              'Row dengan 3 Ikon Berbeda',
              _buildIconRow(),
            ),
            _buildSection(
              context,
              'Column dengan 3 Teks Berbeda Style',
              _buildTextColumn(),
            ),
            _buildSection(
              context,
              'Container dengan Latar Warna',
              _buildContainer(),
            ),
            _buildSection(
              context,
              'Perbandingan Expanded vs Flexible',
              _buildComparisonRows(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home, color: Colors.blue, size: 48),
          Icon(Icons.favorite, color: Colors.red, size: 48),
          Icon(Icons.star, color: Colors.yellow, size: 48),
        ],
      ),
    );
  }

  Widget _buildTextColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teks Bold Besar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Teks Italic Merah',
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.red,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Teks Kecil Hijau',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Hello Container!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRows() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expanded (pembagian ruang sama):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'Expanded 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        'Expanded 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        'Expanded 3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Flexible (rasio 2:1:3):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'Flex 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        'Flex 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        'Flex 3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
