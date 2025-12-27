import 'package:flutter/material.dart';

class NutritionTipsSection extends StatelessWidget {
  const NutritionTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      NutritionTip(
        title: 'Post-COVID Recovery Tips',
        icon: Icons.coronavirus_outlined,
        color: Colors.red,
        tips: [
          'Eat protein-rich foods (dal, paneer, eggs, legumes) at every meal',
          'Include Vitamin C rich foods like amla, lemon, orange daily',
          'Drink warm water throughout the day',
          'Add turmeric and ginger to your meals for anti-inflammatory benefits',
          'Avoid processed foods, sugar, and deep fried items',
          'Include probiotic foods like curd, buttermilk daily',
          'Take kadha (herbal tea) with tulsi, ginger, black pepper',
        ],
      ),
      NutritionTip(
        title: 'Fighting Anemia',
        icon: Icons.bloodtype,
        color: Colors.pink,
        tips: [
          'Eat iron-rich foods: green leafy vegetables, jaggery, dates',
          'Combine iron foods with Vitamin C for better absorption',
          'Avoid tea/coffee immediately after meals',
          'Include beetroot in salads or as juice',
          'Eat pomegranate or its juice regularly',
          'Add moringa (drumstick leaves) to your diet',
          'Use iron cookware for cooking',
        ],
      ),
      NutritionTip(
        title: 'Pregnancy Nutrition',
        icon: Icons.pregnant_woman,
        color: Colors.purple,
        tips: [
          'Take folic acid supplements as advised by doctor',
          'Eat small, frequent meals to avoid nausea',
          'Include calcium-rich foods: milk, curd, ragi',
          'Eat protein at every meal for baby\'s growth',
          'Avoid raw or undercooked foods',
          'Stay hydrated with water, coconut water, buttermilk',
          'Include iron-rich foods to prevent pregnancy anemia',
        ],
      ),
      NutritionTip(
        title: 'Child Nutrition (6 months - 5 years)',
        icon: Icons.child_care,
        color: Colors.blue,
        tips: [
          'Continue breastfeeding along with solid foods till 2 years',
          'Introduce one new food at a time',
          'Include all food groups: grains, proteins, fruits, vegetables',
          'Avoid sugar and salt for babies under 1 year',
          'Give iron-rich foods like ragi, green leafy vegetables',
          'Make food colorful and appealing',
          'Be patient - children may need 10-15 exposures to accept new foods',
        ],
      ),
      NutritionTip(
        title: 'Diabetes-Friendly Diet',
        icon: Icons.monitor_heart,
        color: Colors.orange,
        tips: [
          'Choose whole grains over refined: brown rice, whole wheat',
          'Eat vegetables with every meal',
          'Avoid fruit juices, eat whole fruits instead',
          'Include bitter gourd, fenugreek, cinnamon in diet',
          'Eat small, frequent meals at fixed times',
          'Avoid white rice, maida, sugary foods',
          'Include fiber-rich foods to control blood sugar spikes',
        ],
      ),
      NutritionTip(
        title: 'General Wellness',
        icon: Icons.favorite,
        color: Colors.green,
        tips: [
          'Eat a rainbow of fruits and vegetables daily',
          'Drink 8-10 glasses of water daily',
          'Avoid processed and packaged foods',
          'Cook at home using fresh ingredients',
          'Use less oil, prefer mustard/til/coconut oil',
          'Eat seasonal and local foods',
          'Chew food properly and eat mindfully',
        ],
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length,
      itemBuilder: (context, index) => _TipCard(tip: tips[index]),
    );
  }
}

class NutritionTip {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> tips;

  const NutritionTip({
    required this.title,
    required this.icon,
    required this.color,
    required this.tips,
  });
}

class _TipCard extends StatefulWidget {
  final NutritionTip tip;

  const _TipCard({required this.tip});

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.tip.color.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Icon(widget.tip.icon, color: widget.tip.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.tip.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.tip.color,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.tip.color,
                  ),
                ],
              ),
            ),
          ),
          
          // Tips List (expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: widget.tip.tips.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.tip.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: widget.tip.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
