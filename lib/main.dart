import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 0.5, color: Colors.grey[600]),
        ),

        // On mobile: hamburger menu
        leading: isMobile
            ? PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: _onTabSelected,
          itemBuilder: (ctx) => [
            const PopupMenuItem(value: 0, child: Text('Items')),
            const PopupMenuItem(value: 1, child: Text('Pricing')),
            const PopupMenuItem(value: 2, child: Text('Info')),
            const PopupMenuItem(value: 3, child: Text('Tasks')),
            const PopupMenuItem(value: 4, child: Text('Analytics')),
          ],
        )
            : null,

        // Always show logo
        title: SvgPicture.asset('assets/logo.svg'),

        actions: [
          // Desktop: inline nav buttons
          if (!isMobile) ...[
            for (var i = 0; i < 5; i++) ...[
              _NavBarButton(
                title: ['Items', 'Pricing', 'Info', 'Tasks', 'Analytics'][i],
                index: i,
                isSelected: _selectedIndex == i,
                onTap: () => _onTabSelected(i),
              ),
              const SizedBox(width: 16),
            ],
            const Center(
              child: VerticalLine(width: 1, height: 25, color: Color(0xFF3A3A3A)),
            ),
            const SizedBox(width: 16),
          ],

          // Always-shown icons + profile
          IconButton(
            icon: SvgPicture.asset('assets/gear.svg'),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: SvgPicture.asset('assets/notification.svg'),
            onPressed: () {},
          ),
          const SizedBox(width: 24),
          const _UserProfile(),
          const SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          // Add a New Item button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Items', style: TextStyle(fontSize: 32)),
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset('assets/settings.svg'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    const Center(
                      child: VerticalLine(width: 1, height: 48, color: Color(0xFF3A3A3A)),
                    ),
                    const SizedBox(width: 24),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        backgroundColor: const Color(0xFFFFC268),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text(
                        'Add a New Item',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Display selected screen
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
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
            const SizedBox(height: 30),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF999999),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            if (isSelected)
              Container(
                height: 2,
                width: 50,
                color: isSelected ? const Color(0xFFFFC268) : Colors.black,
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
    return Row(
      children: [
        Image.asset('assets/pp.png'),
        const SizedBox(width: 8),
        const Text(
          'John Doe',
          style: TextStyle(color: Colors.white),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
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
        int columns = (constraints.maxWidth ~/ 300).clamp(1, 5); // Minimum of 1 column, max of 4
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: 8, // or however many cards you have
          itemBuilder: (ctx, i) {
            final assetName = 'assets/card${i+1}.png';
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(assetName, fit: BoxFit.cover),
            );
          },
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

class VerticalLine extends StatelessWidget {
  final double width;

  final double height;

  final Color color;

  const VerticalLine({
    Key? key,
    required this.width,
    required this.height,
    this.color = const Color(0xFF2A2A2A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(width / 2),
        ),
      ),
    );
  }
}
