import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/widgets.dart';

class VacancyScreen extends StatefulWidget {
  const VacancyScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  State<VacancyScreen> createState() => _VacancyScreenState();
}

class _VacancyScreenState extends State<VacancyScreen> {
  int filter = 0;
  String search = '';
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = widget.page == 0;
    return Scene(
      header: PageHeader(
        home ? 'Job Seeker' : '',
        back: home ? null : () => widget.go(0),
        action: home ? Icons.search : Icons.more_horiz,
        onAction: () => home
            ? _search(context)
            : toast(context, 'Remote friendly · Full time · Product team'),
      ),
      body: PageBody(
        children: home
            ? [
                Choices(
                  labels: const ['All', 'Development', '.Net', 'C#', 'Java'],
                  selected: filter,
                  onChanged: (i) => setState(() => filter = i),
                ),
                gap(16),
                if (search.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: label(
                      'Results for “$search”',
                      color: SpotColors.muted,
                    ),
                  ),
                section('Hottest vacancies'),
                InkWell(
                  onTap: () => widget.go(1),
                  child: surface(
                    padding: const EdgeInsets.all(12),
                    color: SpotColors.canvas.withValues(alpha: .45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        art(
                          'job-featured',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        gap(10),
                        label(
                          filter == 0
                              ? ' .Net Software Engineer at Google'
                              : ' ${['All', 'Development', '.Net', 'C#', 'Java'][filter]} Software Engineer',
                          size: 12,
                          color: SpotColors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                section('Latest vacancies'),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: .98,
                  children: [
                    for (final job in [
                      ('Business Analyst', 'job-analyst'),
                      ('Recruiter', 'job-recruiter'),
                      ('Product Designer', 'job-designer'),
                      ('Developer', 'job-developer'),
                    ])
                      if (search.isEmpty ||
                          job.$1.toLowerCase().contains(search.toLowerCase()))
                        InkWell(
                          onTap: () => widget.go(1),
                          child: surface(
                            padding: const EdgeInsets.all(10),
                            color: SpotColors.canvas.withValues(alpha: .6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: art(
                                    job.$2,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                gap(7),
                                label(job.$1, size: 12),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
                if (search.isNotEmpty &&
                    ![
                      'business analyst',
                      'recruiter',
                      'product designer',
                      'developer',
                    ].any((j) => j.contains(search.toLowerCase())))
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: label(
                      'No exact matches. Try “designer” or “developer”.',
                      color: SpotColors.muted,
                    ),
                  ),
              ]
            : [
                label(
                  'Business Analyst Position',
                  size: 22,
                  weight: FontWeight.w500,
                ),
                gap(16),
                art('job-detail', height: 210, fit: BoxFit.contain),
                gap(18),
                _requirements(
                  'Experience',
                  SpotColors.lavender,
                  '2+ years in business analysis. Translate product needs into clear, actionable requirements.',
                ),
                _requirements(
                  'To be responsible for',
                  SpotColors.rose,
                  'Work with design and engineering teams. Map user journeys and evaluate product results.',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Would be nice to have', size: 18),
                      gap(8),
                      label(
                        '• Stakeholder satisfaction\n• End user satisfaction\n• Team satisfaction',
                        size: 13,
                      ),
                    ],
                  ),
                ),
                _requirements(
                  'Benefits',
                  SpotColors.mint,
                  'Flexible hours, learning budget, a friendly team and the freedom to work remotely.',
                ),
                gap(18),
                Row(
                  children: [
                    SizedBox(
                      width: 95,
                      child: actionButton(
                        widget.state.favorite('job') ? 'Saved ✓' : 'Save',
                        () => widget.state.toggle('favorite.job'),
                        outlined: true,
                        color: SpotColors.ink,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: actionButton(
                        widget.state.value('applied', false)
                            ? 'Application saved ✓'
                            : 'Apply Now',
                        () => _apply(context),
                      ),
                    ),
                  ],
                ),
              ],
      ),
    );
  }

  Widget _requirements(String title, Color color, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: color,
        collapsedBackgroundColor: color,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        minTileHeight: 48,
        title: label(title, size: 16),
        trailing: const Icon(Icons.add, size: 20),
        children: [label(text, size: 13)],
      ),
    ),
  );
  void _search(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Find your next role'),
      content: TextField(
        controller: searchController,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Designer, developer…'),
        onSubmitted: (value) {
          setState(() => search = value.trim());
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            searchController.clear();
            setState(() => search = '');
            Navigator.pop(context);
          },
          child: const Text('Clear'),
        ),
        FilledButton(
          onPressed: () {
            setState(() => search = searchController.text.trim());
            Navigator.pop(context);
          },
          child: const Text('Search'),
        ),
      ],
    ),
  );
  void _apply(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Save your interest?'),
      content: const Text(
        'This demo saves the role on this device. A live recruiting service can be connected to submit your profile.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.state.set('applied', true);
            Navigator.pop(context);
            toast(this.context, 'Your interest in this role has been saved');
          },
          child: const Text('Save interest'),
        ),
      ],
    ),
  );
}
