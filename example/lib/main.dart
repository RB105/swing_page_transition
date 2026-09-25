import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:swing_page_transition/swing_page_transition.dart';

void main() => runApp(const SwingDemoApp());

const _accent = Color(0xFF009DE0);

class SwingDemoApp extends StatelessWidget {
  const SwingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swing page transition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: _accent,
        // Every MaterialPageRoute in the app now swings in.
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SwingPageTransitionsBuilder(),
            TargetPlatform.iOS: SwingPageTransitionsBuilder(),
          },
        ),
      ),
      home: const DiscoveryPage(),
    );
  }
}

class Venue {
  const Venue(this.name, this.tagline, this.color, this.icon);

  final String name;
  final String tagline;
  final Color color;
  final IconData icon;
}

const venues = [
  Venue(
    'Burger Lab',
    'Smash burgers · 25–35 min',
    Color(0xFFFF7043),
    Icons.lunch_dining,
  ),
  Venue(
    'Sushi Go',
    'Rolls & poke · 30–40 min',
    Color(0xFF26A69A),
    Icons.set_meal,
  ),
  Venue(
    'Pizza Napoli',
    'Wood-fired · 20–30 min',
    Color(0xFFEF5350),
    Icons.local_pizza,
  ),
  Venue(
    'Green Bowl',
    'Salads & bowls · 15–25 min',
    Color(0xFF66BB6A),
    Icons.eco,
  ),
  Venue(
    'Coffee Point',
    'Coffee & desserts · 10–20 min',
    Color(0xFF8D6E63),
    Icons.coffee,
  ),
];

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  bool _slowMotion = timeDilation > 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discovery',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          const Text('Slow-mo'),
          Switch(
            value: _slowMotion,
            onChanged: (value) => setState(() {
              _slowMotion = value;
              timeDilation = value ? 6 : 1;
            }),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: venues.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final venue = venues[i];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => VenuePage(venue: venue)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: venue.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(venue.icon, size: 64, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  venue.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  venue.tagline,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VenuePage extends StatelessWidget {
  const VenuePage({super.key, required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: venue.color,
        foregroundColor: Colors.white,
        title: Text(venue.name),
      ),
      body: ListView(
        children: [
          Container(
            height: 180,
            color: venue.color,
            child: Icon(venue.icon, size: 96, color: Colors.white),
          ),
          for (var i = 1; i <= 8; i++)
            ListTile(
              title: Text('${venue.name} special #$i'),
              subtitle: const Text('Tap to open the item'),
              trailing: Text('\$${i * 3 + 6}'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ItemPage(
                    title: '${venue.name} special #$i',
                    color: venue.color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  const ItemPage({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.alphaBlend(color.withAlpha(30), Colors.white),
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: _accent),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Add to order'),
        ),
      ),
    );
  }
}
