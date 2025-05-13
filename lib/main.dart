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

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
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

  // Active tab state
  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const ItemsScreen(),
    const PlaceholderScreen(title: "Pricing"),
    const PlaceholderScreen(title: "Info"),
    const PlaceholderScreen(title: "Tasks"),
    const PlaceholderScreen(title: "Analytics"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Adjust the height as needed
        backgroundColor: Colors.black,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 0.5,color: Colors.grey[600])),
        title: Row(
          children: [
            const Text(
              'Logo',
              style: TextStyle(fontSize: 32),
            ),
            const Spacer(), // Pushes the menu items to the right
            _NavBarButton(
              title: 'Items',
              index: 0,
              isSelected: _selectedIndex == 0,
              onTap: () => _onTabSelected(0),
            ),
            _NavBarButton(
              title: 'Pricing',
              index: 1,
              isSelected: _selectedIndex == 1,
              onTap: () => _onTabSelected(1),
            ),
            _NavBarButton(
              title: 'Info',
              index: 2,
              isSelected: _selectedIndex == 2,
              onTap: () => _onTabSelected(2),
            ),
            _NavBarButton(
              title: 'Tasks',
              index: 3,
              isSelected: _selectedIndex == 3,
              onTap: () => _onTabSelected(3),
            ),
            _NavBarButton(
              title: 'Analytics',
              index: 4,
              isSelected: _selectedIndex == 4,
              onTap: () => _onTabSelected(4),
            ),
            const SizedBox(width: 16), // Space between menu items and icons
            // Adding the settings and notifications icons
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {}, // Settings functionality
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {}, // Notification functionality
            ),
            const SizedBox(width: 16), // Space before the username and dropdown
            // Adding the user profile (Username + Dropdown)
            const _UserProfile(),
          ],
        ),
      ),
      body: Column(
        children: [
          // Add a New Item button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 32),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white), // Placeholder icon
                      onPressed: () {}, // Icon functionality
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('Add a New Item', style: TextStyle(color: Colors.black)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Space between button and content

          // Display selected screen
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  // Update the selected tab index
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _NavBarButton extends StatelessWidget {
  final String title;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.title,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            if (isSelected)
              Container(
                height: 4,
                width: 50,
                color: isSelected ? Colors.yellow : Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
        ),
        SizedBox(width: 8),
        Text(
          'John Doe',
          style: TextStyle(color: Colors.white),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
      ],
    );
  }
}

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = (constraints.maxWidth ~/ 300).clamp(1, 4); // Minimum of 1 column, max of 4
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: 8,
          itemBuilder: (ctx, i) => ItemCard(imageUrl: 'https://picsum.photos/seed/$i/800/600'),
        );
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(fontSize: 24, color: Colors.white),
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
            aspectRatio: 16 / 9,
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
