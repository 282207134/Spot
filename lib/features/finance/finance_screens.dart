import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/widgets.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({
    super.key,
    required this.product,
    required this.page,
    required this.go,
    required this.state,
  });
  final String product;
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int card = 0;
  @override
  void initState() {
    super.initState();
    card = widget.state.value('paymentCard', 0);
  }

  String recipient = 'Tommy';
  @override
  Widget build(BuildContext context) => switch (widget.product) {
    'banking' => _banking(context),
    'subscription' => _subscriptions(context),
    _ => _wallet(context),
  };
  Widget _wallet(BuildContext context) {
    final home = widget.page == 0;
    return Scene(
      header: PageHeader(
        home ? 'Wallet' : 'Cards',
        large: home,
        back: home ? null : () => widget.go(0),
        action: Icons.tune,
        onAction: () => toast(context, 'Currency: USD · All accounts'),
      ),
      bottom: ProductNavigation(
        index: home ? 0 : 1,
        onSelect: (i) => i == 0
            ? widget.go(0)
            : i == 1
            ? widget.go(1)
            : _amount(context, deposit: i == 2),
      ),
      body: PageBody(
        children: home
            ? [
                Row(
                  children: [
                    Expanded(
                      child: label(
                        '\$ ${_money(widget.state.balance)}',
                        size: 29,
                        weight: FontWeight.w500,
                      ),
                    ),
                    surface(
                      color: SpotColors.ink,
                      radius: 5,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      child: label('USD', size: 11, color: Colors.white),
                    ),
                  ],
                ),
                gap(24),
                Row(
                  children: [
                    Expanded(
                      child: actionButton(
                        'Deposit',
                        () => _amount(context, deposit: true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: actionButton(
                        'Withdraw',
                        () => _amount(context),
                        color: SpotColors.pink,
                      ),
                    ),
                  ],
                ),
                section(
                  'Cards',
                  action: 'View all',
                  onAction: () => widget.go(1),
                ),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    separatorBuilder: (_, i) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () => widget.go(1),
                      child: BankCard(
                        color: i == 0 ? SpotColors.lavender : SpotColors.rose,
                        width: 240,
                        balance: i == 0 ? '8,2374.00' : '3,335.90',
                        compact: true,
                      ),
                    ),
                  ),
                ),
                section(
                  'Payments',
                  action: 'View all',
                  onAction: () =>
                      toast(context, 'All upcoming payments are shown.'),
                ),
                _paymentStrip(),
                section(
                  'Transactions',
                  action: 'View all',
                  onAction: () => widget.go(1),
                ),
                _transaction(
                  'Bank invoice',
                  'Capital One',
                  '+ \$2,300.00',
                  SpotColors.blue,
                  Icons.account_balance,
                ),
                if (widget.state.value<num>('lastTransfer', 0) > 0)
                  _transaction(
                    'Your transfer',
                    'Completed locally',
                    '− \$${widget.state.value<num>('lastTransfer', 0).toStringAsFixed(2)}',
                    SpotColors.pink,
                    Icons.arrow_outward,
                  ),
              ]
            : [
                SizedBox(
                  height: 190,
                  child: PageView(
                    onPageChanged: (i) => setState(() => card = i),
                    children: [
                      for (final c in [SpotColors.lavender, SpotColors.rose])
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: BankCard(
                            color: c,
                            width: 327,
                            balance: '8,2374.00',
                          ),
                        ),
                    ],
                  ),
                ),
                gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == card ? 7 : 5,
                        height: i == card ? 7 : 5,
                        decoration: BoxDecoration(
                          color: i == card
                              ? SpotColors.blue
                              : const Color(0xFFCED1DA),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                section(
                  'History',
                  action: 'View all',
                  onAction: () =>
                      toast(context, 'Showing all local transactions.'),
                ),
                label('Yesterday', size: 16),
                gap(10),
                _transaction(
                  'Cashback',
                  'Capital One',
                  '+ \$48.50',
                  SpotColors.muted,
                  Icons.credit_card,
                ),
                _transaction(
                  'Burger King',
                  'Capital One',
                  '− \$32.48',
                  SpotColors.pink,
                  Icons.fastfood,
                ),
                gap(12),
                label('19 December', size: 16),
                gap(10),
                _transaction(
                  'Bank invoice',
                  'Capital One',
                  '+ \$2,300.00',
                  SpotColors.blue,
                  Icons.account_balance,
                ),
                _transaction(
                  'Card Transfer',
                  'Capital One',
                  '− \$500.00',
                  SpotColors.ink,
                  Icons.credit_card,
                ),
              ],
      ),
    );
  }

  Widget _banking(BuildContext context) {
    final transfer = widget.page == 2;
    final overlay = widget.page == 1;
    final body = PageBody(
      children: [
        surface(
          color: SpotColors.rose,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: label(
                      '•••• 2369',
                      size: 11,
                      color: SpotColors.muted,
                    ),
                  ),
                  label('USD Wallet', size: 11),
                  const SizedBox(width: 8),
                  const Icon(Icons.expand_more, size: 15),
                ],
              ),
              gap(22),
              label('Bank of America', size: 22),
              gap(transfer ? 14 : 24),
              if (transfer) label('Drag & Drop ↓', color: SpotColors.muted),
              LongPressDraggable<String>(
                data: 'balance',
                feedback: Material(
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: label(
                      '\$ ${_money(widget.state.value<num>('bankBalance', 16803.40).toDouble())}',
                      size: 21,
                    ),
                  ),
                ),
                child: surface(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  radius: 6,
                  child: label(
                    '\$ ${_money(widget.state.value<num>('bankBalance', 16803.40).toDouble())}',
                    size: 24,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        gap(12),
        surface(
          color: SpotColors.lavender,
          child: Row(
            children: [
              surface(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.shopping_bag, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label('Cruise Spends', size: 12),
                    label('\$ 1,834.99 Available \$ 4,500.00', size: 11),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (transfer) ...[
          section(
            'Transfer Money',
            action: '⌕',
            onAction: () => _send(context),
          ),
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, i) => const SizedBox(width: 16),
              itemBuilder: (_, i) {
                final name = ['Add', 'Tommy', 'Kira', 'Lisa', 'Amile'][i];
                return DragTarget<String>(
                  onAcceptWithDetails: (_) {
                    setState(() => recipient = name);
                    _send(context);
                  },
                  builder: (_, candidates, rejected) => InkWell(
                    onTap: () {
                      setState(() => recipient = name);
                      _send(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: candidates.isNotEmpty
                                  ? SpotColors.blue
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: i == 0
                              ? const CircleAvatar(
                                  backgroundColor: SpotColors.canvas,
                                  radius: 24,
                                  child: Icon(
                                    Icons.add,
                                    color: SpotColors.muted,
                                  ),
                                )
                              : avatar(
                                  i.isEven ? 'avatar-player' : 'avatar-john',
                                  size: 48,
                                ),
                        ),
                        gap(7),
                        label(name, size: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          gap(22),
          actionButton(
            'Create New Action',
            () => _send(context),
            outlined: true,
            color: SpotColors.ink,
          ),
        ] else ...[
          section('History', action: '•••', onAction: () => widget.go(1)),
          _transaction(
            'Transfer Money',
            'To Joel',
            '− \$72.00',
            SpotColors.muted,
            Icons.person_outline,
            person: 'avatar-john',
          ),
          _transaction(
            'Income Money',
            'From Amanda',
            '+ \$218.00',
            SpotColors.muted,
            Icons.person_outline,
            person: 'avatar-player',
          ),
          InkWell(
            onTap: () => widget.go(1),
            child: _transaction(
              'App Store',
              'Subscription',
              '− \$14.98',
              SpotColors.ink,
              Icons.shopping_bag,
            ),
          ),
          _transaction(
            'Income Money',
            'From Simon',
            '+ \$3,000.00',
            SpotColors.muted,
            Icons.person_outline,
            person: 'avatar-tim',
          ),
          gap(12),
          actionButton('Transfer money', () => widget.go(2)),
        ],
      ],
    );
    return Scene(
      header: PageHeader(
        'Hey, Andy!',
        action: Icons.more_vert,
        onAction: () => widget.go(2),
      ),
      body: overlay
          ? Stack(
              children: [
                body,
                const Positioned.fill(
                  child: ColoredBox(color: Color(0x66000618)),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: .88,
                    child: surface(
                      radius: 24,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                      child: ListView(
                        children: [
                          Center(
                            child: surface(
                              color: SpotColors.canvas,
                              radius: 40,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.credit_card, size: 26),
                            ),
                          ),
                          gap(14),
                          label('App Store', size: 23, align: TextAlign.center),
                          label(
                            'Subscriptions',
                            color: SpotColors.muted,
                            size: 13,
                            align: TextAlign.center,
                          ),
                          gap(20),
                          const BarChart(
                            values: [.76, .31, .75, .75, .3, .28, .76],
                            color: SpotColors.green,
                            labels: [
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov',
                              'Dec',
                            ],
                            height: 145,
                          ),
                          section('History'),
                          _transaction(
                            'Apple Music',
                            'Subscription',
                            '− \$9.99',
                            SpotColors.ink,
                            Icons.music_note,
                          ),
                          _transaction(
                            'App Arcade',
                            'Subscription',
                            '− \$4.99',
                            SpotColors.ink,
                            Icons.sports_esports,
                          ),
                          actionButton(
                            'Back to dashboard',
                            () => widget.go(0),
                            outlined: true,
                          ),
                          gap(20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : body,
    );
  }

  Widget _subscriptions(BuildContext context) {
    final home = widget.page == 0;
    final names = [
      'Alto’s Odysseys',
      'Machinarium',
      'Minecraft',
      'The Room: Old Sin',
      'Limbo',
    ];
    final prices = [.24, 2.39, 6.99, 2.39, 4.80];
    final images = [
      'game-alto',
      'game-machinarium',
      'game-minecraft',
      'game-room',
      'game-limbo',
    ];
    return Scene(
      background: home ? const Color(0xFF969AA4) : SpotColors.canvas,
      header: PageHeader(
        home ? 'Your Purchases' : 'Available Cards',
        color: home ? Colors.white : SpotColors.ink,
        large: home,
        back: home ? null : () => widget.go(0),
        action: home ? Icons.more_vert : Icons.close,
        onAction: () => home ? _newPurchase(context) : widget.go(0),
      ),
      body: PageBody(
        children: home
            ? [
                gap(12),
                surface(
                  child: Row(
                    children: [
                      Expanded(child: metric('November Payments', '\$ 67.31')),
                      Expanded(
                        child: metric('All Period Payments', '\$ 340.15'),
                      ),
                    ],
                  ),
                ),
                gap(24),
                for (var i = 0; i < names.length; i++)
                  InkWell(
                    onTap: () => widget.go(1),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          art(images[i], width: 70, height: 70),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                label(names[i], size: 14),
                                label(
                                  '\$ ${prices[i].toStringAsFixed(2)}',
                                  size: 24,
                                ),
                                label(
                                  'Show more games by this developer →',
                                  size: 9,
                                  color: SpotColors.muted,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.state.value('customPurchase', '').isNotEmpty)
                  surface(
                    child: Row(
                      children: [
                        const Icon(Icons.subscriptions_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: label(
                            widget.state.value('customPurchase', ''),
                          ),
                        ),
                        label(
                          '\$ ${widget.state.value('customPrice', '0.00')}',
                        ),
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton.small(
                    heroTag: 'purchase',
                    onPressed: () => _newPurchase(context),
                    backgroundColor: const Color(0xFF666B78),
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.add, size: 30),
                  ),
                ),
              ]
            : [
                Row(
                  children: [
                    art('game-alto', width: 76, height: 76),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label('Alto’s Odysseys', color: SpotColors.muted),
                          label('\$ 0.24', size: 26),
                          label(
                            'Show more games by this developer →',
                            size: 9,
                            color: SpotColors.muted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                gap(24),
                surface(
                  color: const Color(0xFF969AA4),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label(
                        'Choose payment method',
                        size: 21,
                        color: Colors.white,
                      ),
                      gap(24),
                      SizedBox(
                        height: 345,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          separatorBuilder: (_, i) => const SizedBox(width: 16),
                          itemBuilder: (_, i) => InkWell(
                            onTap: () {
                              setState(() => card = i);
                              widget.state.set('paymentCard', i);
                              toast(
                                context,
                                '${i == 0 ? 'Mastercard' : 'Visa'} selected for your purchase',
                              );
                            },
                            child: Container(
                              width: 195,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: card == i
                                      ? SpotColors.blue
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: BankCard(
                                  color: i == 0
                                      ? SpotColors.ink
                                      : const Color(0xFFCED2DA),
                                  width: 335,
                                  balance: '1829 5523 5921 9832',
                                  dark: i == 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      gap(24),
                      actionButton(
                        'Add a new card',
                        () => _newCard(context),
                        color: Colors.white,
                        outlined: true,
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }

  Widget _paymentStrip() => SizedBox(
    height: 92,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        surface(
          width: 195,
          color: SpotColors.mint,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(
                Icons.fastfood_outlined,
                size: 30,
                color: SpotColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label('Fast Food', size: 11),
                    label('Subway', size: 15),
                  ],
                ),
              ),
              label('−\$12.50', size: 12),
            ],
          ),
        ),
        const SizedBox(width: 12),
        surface(
          width: 190,
          color: SpotColors.canvas,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.local_cafe, size: 32, color: SpotColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label('Cafeteria', size: 11),
                    label('Crabtree', size: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _transaction(
    String title,
    String subtitle,
    String amount,
    Color color,
    IconData icon, {
    String? person,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        if (person != null)
          avatar(person)
        else
          CircleAvatar(
            radius: 21,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 21),
          ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(subtitle, size: 10, color: SpotColors.muted),
              label(title, size: 13),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            label(
              amount,
              size: 12,
              color: amount.startsWith('+') ? SpotColors.blue : SpotColors.pink,
            ),
            gap(4),
            label('Bank Services', size: 9, color: SpotColors.muted),
          ],
        ),
      ],
    ),
  );
  Future<void> _amount(BuildContext context, {bool deposit = false}) async {
    var input = '';
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(deposit ? 'Deposit funds' : 'Withdraw funds'),
          content: TextField(
            onChanged: (value) => input = value,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount in USD',
              errorText: error,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(input);
                if (amount == null || !amount.isFinite || amount <= 0) {
                  setDialogState(
                    () => error = 'Enter an amount greater than zero',
                  );
                  return;
                }
                if (!deposit && !widget.state.transfer(amount)) {
                  setDialogState(() => error = 'Insufficient balance');
                  return;
                }
                if (deposit) {
                  widget.state.set('balance', widget.state.balance + amount);
                }
                Navigator.pop(dialogContext);
                toast(
                  context,
                  deposit
                      ? 'Deposit added to your demo wallet'
                      : 'Withdrawal saved in your demo wallet',
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send(BuildContext context) async {
    var input = '';
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text('Send money to $recipient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(
                'Available: \$${_money(widget.state.value<num>('bankBalance', 16803.40).toDouble())}',
                size: 12,
                color: SpotColors.muted,
              ),
              gap(16),
              TextField(
                onChanged: (value) => input = value,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount in USD',
                  errorText: error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(input);
                final balance = widget.state
                    .value<num>('bankBalance', 16803.40)
                    .toDouble();
                if (amount == null ||
                    !amount.isFinite ||
                    amount <= 0 ||
                    amount > balance) {
                  setDialogState(
                    () => error = 'Enter a valid amount within your balance',
                  );
                  return;
                }
                widget.state.set('bankBalance', balance - amount);
                widget.state.set('lastBankTransfer', amount);
                Navigator.pop(dialogContext);
                toast(
                  context,
                  'Demo transfer of \$${amount.toStringAsFixed(2)} to $recipient completed',
                );
              },
              child: const Text('Send demo transfer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _newPurchase(BuildContext context) async {
    var name = '', price = '';
    String? error;
    await showDialog<void>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setDialog) => AlertDialog(
          title: const Text('Add a purchase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(labelText: 'App name'),
              ),
              gap(12),
              TextField(
                onChanged: (value) => price = value,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Monthly price',
                  errorText: error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(price);
                if (name.trim().isEmpty ||
                    amount == null ||
                    !amount.isFinite ||
                    amount < 0) {
                  setDialog(
                    () => error = 'Enter an app name and a valid price',
                  );
                  return;
                }
                widget.state.set('customPurchase', name.trim());
                widget.state.set('customPrice', amount.toStringAsFixed(2));
                Navigator.pop(c);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _newCard(BuildContext context) => showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Add a demo card'),
      content: const Text(
        'Use the existing Mastercard or Visa to explore the payment selection. Real card information is not collected in this demo.',
      ),
      actions: [
        FilledButton(
          onPressed: () {
            widget.state.set('paymentCard', 1);
            setState(() => card = 1);
            Navigator.pop(c);
          },
          child: const Text('Select Visa'),
        ),
      ],
    ),
  );
  String _money(double n) {
    final parts = n.toStringAsFixed(2).split('.');
    return '${parts[0].replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}.${parts[1]}';
  }
}

class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.color,
    required this.width,
    required this.balance,
    this.dark = false,
    this.compact = false,
  });
  final Color color;
  final double width;
  final String balance;
  final bool dark, compact;
  @override
  Widget build(BuildContext context) {
    final ink = dark ? Colors.white : SpotColors.ink;
    return surface(
      color: color,
      width: width,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.credit_card,
                size: 20,
                color: dark ? SpotColors.blue : SpotColors.pink,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: label(
                  'Capital One',
                  size: 11,
                  color: ink.withValues(alpha: .65),
                ),
              ),
              label(
                'VISA',
                size: 15,
                color: dark ? Colors.white : const Color(0xFF1760B1),
                weight: FontWeight.w700,
              ),
            ],
          ),
          gap(compact ? 12 : 22),
          label(
            compact
                ? '\$ $balance'
                : dark
                ? balance
                : '4479 0323 4583 0341',
            size: compact ? 21 : 19,
            color: ink,
            weight: FontWeight.w500,
          ),
          gap(compact ? 10 : 22),
          Row(
            children: [
              Expanded(
                child: label(
                  'Cardholder Name',
                  size: 10,
                  color: ink.withValues(alpha: .6),
                ),
              ),
              label('07/28', size: 11, color: ink),
            ],
          ),
        ],
      ),
    );
  }
}
