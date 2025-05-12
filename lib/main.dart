import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Items',
      theme: ThemeData.dark(),
      home: const ItemsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  // Dummy data
  final List<String> imageUrls = const [
    'https://picsum.photos/seed/1/800/600',
    'https://picsum.photos/seed/2/800/600',
    'https://picsum.photos/seed/3/800/600',
    'https://picsum.photos/seed/4/800/600',
    'https://picsum.photos/seed/5/800/600',
    'https://picsum.photos/seed/6/800/600',
    'https://picsum.photos/seed/7/800/600',
    'https://picsum.photos/seed/8/800/600',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text('Add a New Item', style: TextStyle(color: Colors.black)),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // choose grid vs list based on width
          final bool isWide = constraints.maxWidth >= 600;
          if (isWide) {
            // 2–4 columns depending on width
            final cols = (constraints.maxWidth ~/ 250).clamp(2, 4);
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3/4,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (ctx, i) => ItemCard(imageUrl: imageUrls[i]),
            );
          } else {
            // single column list
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: imageUrls.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ItemCard(imageUrl: imageUrls[i]),
              ),
            );
          }
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String imageUrl;
  const ItemCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          AspectRatio(
            aspectRatio: 16/9,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          // status dropdown
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButton<String>(
              value: 'Pending Approval',
              isDense: true,
              underline: Container(),
              items: const [
                DropdownMenuItem(value: 'Pending Approval', child: Text('Pending Approval')),
                DropdownMenuItem(value: 'Approved', child: Text('Approved')),
              ],
              onChanged: (_) {},
            ),
          ),
          // title & dates
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Item title', style: Theme.of(context).textTheme.headlineMedium),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 4),
                Text('5 Nights (Jan 16 – Jan 20, 2024)'),
              ],
            ),
          ),
          const Spacer(),
          // footer avatars & tasks
          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                // example avatars
                CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3')),
                SizedBox(width: 4),
                Text('+6'),
                Spacer(),
                Text('4 unfinished tasks'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
