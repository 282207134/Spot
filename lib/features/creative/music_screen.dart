import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/widgets.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool playing = false, shuffle = false, repeat = false;
  double position = 83, volume = .55;
  int track = 0;
  Timer? timer;
  static const tracks = [
    ('Elvis Presley', "It’s Now or Never"),
    ('Nirvana', 'You Know You’re Right'),
    ('Bloodhound Gang', 'The Bad Touch'),
  ];
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void play() {
    setState(() => playing = !playing);
    timer?.cancel();
    if (playing) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() => position = position >= 142 ? 0 : position + 1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF666B76);
    final home = widget.page == 0;
    return Scene(
      background: bg,
      header: PageHeader(
        home ? 'Media Library' : 'Dance',
        large: home,
        subtitle: home ? 'Top songs app' : null,
        avatar: home ? 'avatar-player' : null,
        color: Colors.white,
        back: home ? null : () => widget.go(0),
        action: home ? null : Icons.more_vert,
        onAction: () =>
            toast(context, 'Playback controls run locally in this UI demo.'),
      ),
      bottom: ProductNavigation(
        index: home ? 0 : 2,
        dark: true,
        onSelect: (i) => widget.go(i == 0 ? 0 : 1),
        icons: const [
          Icons.queue_music,
          Icons.bar_chart,
          Icons.music_note,
          Icons.search,
        ],
      ),
      body: PageBody(
        children: home
            ? [
                _collection(
                  context,
                  'Mood playlist',
                  [
                    ('Dance Collection', 'music-dance'),
                    ('Chill Collection', 'music-chill'),
                  ],
                  190,
                  150,
                ),
                _collection(
                  context,
                  'Top-100 from 2019',
                  [
                    ('Awarded songs', 'music-awarded'),
                    ('Nominated songs', 'music-nominated'),
                  ],
                  158,
                  98,
                ),
                section(
                  'Recommendations',
                  color: Colors.white,
                  action: 'See all',
                  onAction: () => widget.go(1),
                ),
                for (var i = 1; i < 3; i++)
                  InkWell(
                    onTap: () {
                      setState(() => track = i);
                      widget.go(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Row(
                        children: [
                          surface(
                            color: i == 1 ? SpotColors.green : SpotColors.pink,
                            padding: const EdgeInsets.all(12),
                            child: const Icon(Icons.album, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                label(tracks[i].$1, color: Colors.white),
                                label(
                                  tracks[i].$2,
                                  color: Colors.white54,
                                  size: 11,
                                ),
                              ],
                            ),
                          ),
                          label('3:37', color: Colors.white70, size: 11),
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
              ]
            : [
                art('music-cover', height: 220),
                gap(30),
                label(
                  tracks[track].$1,
                  size: 25,
                  color: Colors.white,
                  align: TextAlign.center,
                ),
                gap(6),
                label(
                  tracks[track].$2,
                  color: Colors.white60,
                  align: TextAlign.center,
                ),
                gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    label(
                      '${position.toInt() ~/ 60}:${(position.toInt() % 60).toString().padLeft(2, '0')}',
                      size: 10,
                      color: Colors.white70,
                    ),
                    label('2:22', size: 10, color: Colors.white70),
                  ],
                ),
                Slider(
                  value: position,
                  min: 0,
                  max: 142,
                  onChanged: (v) => setState(() => position = v),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Shuffle',
                      onPressed: () => setState(() => shuffle = !shuffle),
                      icon: Icon(
                        Icons.shuffle,
                        color: shuffle ? SpotColors.blue : Colors.white,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Previous track',
                      onPressed: () => setState(() {
                        track = (track + 2) % 3;
                        position = 0;
                      }),
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    IconButton(
                      tooltip: playing ? 'Pause' : 'Play',
                      onPressed: play,
                      icon: Icon(
                        playing
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Next track',
                      onPressed: () => setState(() {
                        track = (track + 1) % 3;
                        position = 0;
                      }),
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Repeat',
                      onPressed: () => setState(() => repeat = !repeat),
                      icon: Icon(
                        Icons.repeat,
                        color: repeat ? SpotColors.blue : Colors.white,
                      ),
                    ),
                  ],
                ),
                gap(22),
                Row(
                  children: [
                    const Icon(
                      Icons.volume_down,
                      color: Colors.white38,
                      size: 18,
                    ),
                    Expanded(
                      child: Slider(
                        value: volume,
                        onChanged: (v) => setState(() => volume = v),
                        activeColor: Colors.white54,
                        inactiveColor: Colors.white24,
                      ),
                    ),
                    const Icon(
                      Icons.volume_up,
                      color: Colors.white38,
                      size: 18,
                    ),
                  ],
                ),
                gap(18),
                TextButton.icon(
                  onPressed: () => widget.state.toggle('favorite.track'),
                  icon: Icon(
                    widget.state.favorite('track')
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white70,
                    size: 18,
                  ),
                  label: label(
                    widget.state.favorite('track')
                        ? 'Added to favourites'
                        : 'Add to favourites',
                    size: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
      ),
    );
  }

  Widget _collection(
    BuildContext context,
    String title,
    List<(String, String)> items,
    double width,
    double height,
  ) => Column(
    children: [
      section(
        title,
        color: Colors.white,
        action: 'See all',
        onAction: () => widget.go(1),
      ),
      SizedBox(
        height: height + 35,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, i) => const SizedBox(width: 12),
          itemBuilder: (_, i) => InkWell(
            onTap: () => widget.go(1),
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  art(items[i].$2, width: width, height: height),
                  gap(7),
                  label(items[i].$1, size: 11, color: Colors.white54),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
