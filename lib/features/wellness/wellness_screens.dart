import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/widgets.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int tab = 0, period = 2;
  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scene(
      background: SpotColors.canvas,
      header: PageHeader(
        widget.page == 0 ? 'Hello, John' : 'Water activity',
        subtitle: widget.page == 0 ? 'Perfect hydration app' : null,
        avatar: widget.page == 0 ? 'avatar-john' : null,
        back: widget.page == 1 ? () => widget.go(0) : null,
        large: widget.page == 0,
      ),
      body: PageBody(
        children: widget.page == 0
            ? [
                InkWell(
                  onTap: () => widget.go(1),
                  borderRadius: BorderRadius.circular(10),
                  child: surface(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: RingChart(
                                  size: 170,
                                  values: [state.water / 1500, .86, .92],
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final item in [
                                    ('Water Balance', SpotColors.blue),
                                    ('Daily Activity', SpotColors.green),
                                    ('Heart Rate', SpotColors.pink),
                                  ])
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: item.$2,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          const SizedBox(width: 7),
                                          Expanded(
                                            child: label(item.$1, size: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            metric('Liquids', '${state.water} ml'),
                            metric('Activity', '45 min'),
                            metric('Pulse', '67 bpm'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                gap(20),
                surface(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: InkWell(
                          onTap: () => setState(() => tab = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: tab == i
                                  ? Colors.white
                                  : SpotColors.canvas.withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: tab == i
                                  ? [
                                      const BoxShadow(
                                        color: Color(0x15000618),
                                        blurRadius: 8,
                                        offset: Offset(1, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: label(
                              ['Body Changes', 'Sleeping', 'Another Data'][i],
                              size: 10,
                              align: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                gap(20),
                for (final info
                    in tab == 0
                        ? [
                            (
                              Icons.water_drop_outlined,
                              SpotColors.blue,
                              'Water Balance is: Normal',
                              'Please drink yet 250ml of water',
                            ),
                            (
                              Icons.local_fire_department,
                              SpotColors.green,
                              'Daily Activity is: Good',
                              'You should go for a walk',
                            ),
                            (
                              Icons.favorite,
                              SpotColors.pink,
                              'Heartbeat is: Good',
                              'Your heart in a good condition',
                            ),
                          ]
                        : tab == 1
                        ? [
                            (
                              Icons.bedtime_outlined,
                              SpotColors.blue,
                              'Sleep quality is: Good',
                              '7 hours 45 minutes of restful sleep',
                            ),
                            (
                              Icons.nights_stay,
                              SpotColors.pink,
                              'Your next bedtime',
                              'Try to wind down at 10:30 PM',
                            ),
                          ]
                        : [
                            (
                              Icons.directions_walk,
                              SpotColors.green,
                              'Daily steps: 6,420',
                              'You are close to your 8,000 step goal',
                            ),
                            (
                              Icons.monitor_heart_outlined,
                              SpotColors.pink,
                              'Resting pulse: 67 bpm',
                              'Within your usual range',
                            ),
                          ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => widget.go(1),
                      child: surface(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            Icon(info.$1, size: 34, color: info.$2),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  label(info.$3, size: 17),
                                  gap(3),
                                  label(
                                    info.$4,
                                    size: 11,
                                    color: SpotColors.muted,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ]
            : [
                surface(
                  child: Column(
                    children: [
                      Choices(
                        labels: const [
                          'Last 30 days',
                          'Last 14 days',
                          'Last 7 days',
                        ],
                        selected: period,
                        onChanged: (i) => setState(() => period = i),
                      ),
                      gap(14),
                      label(
                        '${state.water} ml today',
                        size: 12,
                        weight: FontWeight.w600,
                      ),
                      gap(14),
                      BarChart(
                        values: period == 2
                            ? const [.86, .6, .72, .48, 1, .69, .52]
                            : const [.64, .9, .56, .8, .75, 1, .66],
                        height: 235,
                      ),
                    ],
                  ),
                ),
                gap(18),
                for (final drink in [
                  (
                    Icons.water_drop_outlined,
                    'Water',
                    '500ml',
                    '8:15 am',
                    SpotColors.blue,
                  ),
                  (
                    Icons.local_cafe,
                    'Tea',
                    '150ml',
                    '9:45 am',
                    SpotColors.green,
                  ),
                  (
                    Icons.local_bar,
                    'Cocktail',
                    '250ml',
                    '12:30 pm',
                    SpotColors.pink,
                  ),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: surface(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(drink.$1, color: drink.$5),
                          const SizedBox(width: 12),
                          Expanded(child: label(drink.$2)),
                          label(drink.$3, size: 12, color: SpotColors.muted),
                          const SizedBox(width: 18),
                          label(drink.$4, size: 10, color: SpotColors.muted),
                        ],
                      ),
                    ),
                  ),
                if (state.water > 900)
                  surface(
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop, color: SpotColors.blue),
                        const SizedBox(width: 12),
                        Expanded(child: label('Added water')),
                        label('${state.water - 900}ml', size: 12),
                      ],
                    ),
                  ),
                gap(16),
                actionButton('Add more drinks', () => _addDrink(context)),
              ],
      ),
    );
  }

  void _addDrink(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(
            'A little sip. A better day.',
            size: 24,
            weight: FontWeight.w600,
          ),
          gap(8),
          label(
            'Choose an amount to add to your water log.',
            color: SpotColors.muted,
          ),
          gap(24),
          Row(
            children: [
              for (final amount in [150, 250, 500])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: actionButton('$amount ml', () {
                      widget.state.addWater(amount);
                      Navigator.pop(context);
                      toast(this.context, 'Added $amount ml to your water log');
                    }),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

class JournalScreen extends StatelessWidget {
  const JournalScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  Widget build(BuildContext context) => Scene(
    header: PageHeader(
      page == 0 ? 'Daily Journal' : 'Breakfast',
      large: page == 0,
      back: page == 1 ? () => go(0) : null,
      action: Icons.more_vert,
      onAction: () =>
          toast(context, 'Your nutrition journal is stored on this device.'),
    ),
    body: PageBody(
      children: page == 0
          ? [
              section(
                'Description',
                action: 'More info',
                onAction: () => toast(
                  context,
                  'Daily goal: 2,590 kcal. Add a meal to update your journal.',
                ),
              ),
              surface(
                color: SpotColors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    metric(
                      'Eaten',
                      '${state.calories} kcal',
                      color: Colors.white,
                    ),
                    metric(
                      'Remaining',
                      '${2590 - state.calories} kcal',
                      color: Colors.white,
                    ),
                    metric('Burned', '673 kcal', color: Colors.white),
                  ],
                ),
              ),
              gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final m in [
                    ('Carbs', '59%', .59),
                    ('Protein', '74%', .74),
                    ('Fats', '36%', .36),
                  ])
                    Expanded(
                      child: Center(
                        child: RingChart(
                          size: 88,
                          values: [m.$3],
                          colors: const [SpotColors.blue],
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              label(m.$1, size: 13),
                              label(m.$2, size: 11),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              section(
                'Nourishment',
                action: 'More info',
                onAction: () => go(1),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  for (final name in ['lunch', 'breakfast', 'dinner', 'snack'])
                    InkWell(
                      onTap: () => go(1),
                      child: art('meal-$name', radius: 8),
                    ),
                ],
              ),
            ]
          : [
              art('nutrition-breakfast', height: 160),
              gap(22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  metric('Calories', '340 kcal'),
                  metric('Carbs', '6,4 g'),
                  metric('Protein', '15,9 g'),
                  metric('Fats', '20,3 g'),
                ],
              ),
              gap(26),
              for (final m in [
                ('Tomatos Cherry', '60 g', '14 kcal', SpotColors.rose),
                ('Avocado', '30 g', '48 kcal', SpotColors.mint),
                ('Cheese Bree', '20 g', '76 kcal', SpotColors.lavender),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: surface(
                    color: m.$4,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              label(m.$1, size: 16),
                              label(m.$2, size: 11, color: SpotColors.muted),
                            ],
                          ),
                        ),
                        label(m.$3),
                      ],
                    ),
                  ),
                ),
              gap(12),
              actionButton('Add Product', () {
                state.addMeal();
                go(0);
                toast(context, 'Breakfast added to your daily journal');
              }),
            ],
    ),
  );
}

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  @override
  Widget build(BuildContext context) {
    final home = widget.page == 0;
    return Scene(
      background: home ? SpotColors.ink : Colors.white,
      header: PageHeader(
        home ? 'Tim Panov' : 'Schedule',
        subtitle: home ? 'Online' : null,
        avatar: home ? 'avatar-tim' : null,
        color: home ? Colors.white : SpotColors.ink,
        back: home ? null : () => widget.go(0),
        large: home,
        action: home ? null : Icons.notifications_none,
        onAction: () => toast(context, 'Your reminders are up to date.'),
      ),
      bottom: ProductNavigation(
        index: home ? 0 : 2,
        onSelect: (i) => widget.go(i == 0 ? 0 : 1),
      ),
      body: home
          ? ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 64, 28),
                  child: label(
                    'Hello Tim, you can find all necessary information about your health and daily activities.',
                    size: 15,
                    color: Colors.white,
                  ),
                ),
                surface(
                  radius: 0,
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 24),
                  child: Column(
                    children: [
                      for (final group in [
                        (
                          'Health',
                          Icons.favorite,
                          ['Pulse', 'Sleep', 'Feel good'],
                          [
                            Icons.favorite,
                            Icons.bedtime,
                            Icons.sentiment_satisfied,
                          ],
                        ),
                        (
                          'Trainings',
                          Icons.bar_chart,
                          ['Gym', 'Run', 'Brazilian Jiu-Jitsu'],
                          [
                            Icons.fitness_center,
                            Icons.directions_run,
                            Icons.sports_martial_arts,
                          ],
                        ),
                        (
                          'Diet',
                          Icons.restaurant,
                          ['Food', 'Water', 'Vitamins'],
                          [
                            Icons.restaurant,
                            Icons.water_drop_outlined,
                            Icons.medication_outlined,
                          ],
                        ),
                      ])
                        Column(
                          children: [
                            section(
                              group.$1,
                              action: '•••',
                              onAction: () => widget.go(1),
                            ),
                            SizedBox(
                              height: 88,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                separatorBuilder: (_, index) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (_, i) => InkWell(
                                  onTap: () => widget.go(1),
                                  child: surface(
                                    width: 132,
                                    color: [
                                      SpotColors.rose,
                                      SpotColors.lavender,
                                      SpotColors.canvas,
                                    ][i],
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: label(
                                                group.$3[i],
                                                size: 16,
                                                lines: 1,
                                              ),
                                            ),
                                            Icon(
                                              group.$4[i],
                                              size: 21,
                                              color: i == 0
                                                  ? SpotColors.pink
                                                  : SpotColors.blue,
                                            ),
                                          ],
                                        ),
                                        label(
                                          'Show info',
                                          size: 12,
                                          color: SpotColors.muted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            gap(8),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            )
          : PageBody(
              children: [
                _schedule(
                  context,
                  'Brazilian Jiu-Jitsu Trainings',
                  'Start at 20:30',
                  'Finish at 22:00',
                  SpotColors.rose,
                  0,
                  days: true,
                ),
                gap(16),
                _schedule(
                  context,
                  'Water Balance',
                  '0.200 L per 1 hour',
                  'Every day reminder',
                  SpotColors.canvas,
                  1,
                ),
                gap(16),
                _schedule(
                  context,
                  'Self Education Workshop',
                  'Figma & Sketch Features',
                  'Meeting Room',
                  SpotColors.lavender,
                  2,
                ),
              ],
            ),
    );
  }

  Widget _schedule(
    BuildContext context,
    String title,
    String sub,
    String detail,
    Color color,
    int id, {
    bool days = false,
  }) => surface(
    color: color,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: label(title, size: 17, weight: FontWeight.w500)),
            const Icon(Icons.more_vert, size: 18),
          ],
        ),
        gap(12),
        if (days) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final d in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ['Mon', 'Wed', 'Fri'].contains(d)
                        ? SpotColors.pink
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: label(
                    d,
                    size: 10,
                    color: ['Mon', 'Wed', 'Fri'].contains(d)
                        ? Colors.white
                        : SpotColors.muted,
                  ),
                ),
            ],
          ),
          gap(14),
        ],
        label(sub, size: 12, color: SpotColors.muted),
        gap(14),
        Row(
          children: [
            Expanded(child: label(detail, size: 12)),
            Switch.adaptive(
              value: widget.state.value('reminder.$id', true),
              activeTrackColor: SpotColors.pink,
              onChanged: (v) => widget.state.set('reminder.$id', v),
            ),
          ],
        ),
      ],
    ),
  );
}
