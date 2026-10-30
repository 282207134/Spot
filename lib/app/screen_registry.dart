import 'package:flutter/material.dart';

class Product {
  const Product(
    this.id,
    this.name,
    this.subtitle,
    this.icon,
    this.color,
    this.screens,
  );
  final String id, name, subtitle;
  final IconData icon;
  final Color color;
  final List<String> screens;
}

const products = [
  Product(
    'hydration',
    'Hydra',
    'Hydration & daily balance',
    Icons.water_drop_outlined,
    Color(0xFF558AF8),
    ['Overview', 'Water activity'],
  ),
  Product(
    'drawing',
    'Drawi',
    'A little creativity, every day',
    Icons.brush_outlined,
    Color(0xFFF2D6E2),
    ['Discover', 'Drawing tutorial'],
  ),
  Product(
    'vacancy',
    'Job Seeker',
    'Find your next opportunity',
    Icons.work_outline,
    Color(0xFFD0F3E6),
    ['Vacancies', 'Job details'],
  ),
  Product(
    'shop',
    'The Top Shop',
    'Everyday essentials',
    Icons.shopping_bag_outlined,
    Color(0xFFF2D6E2),
    ['Shop', 'Product details', 'Confirmation'],
  ),
  Product(
    'toothbrush',
    'T-Brush',
    'Make your everyday brighter',
    Icons.electric_bolt_outlined,
    Color(0xFF167CF9),
    ['Discover', 'Toothbrushes', 'Goby details'],
  ),
  Product(
    'banking',
    'Everyday Bank',
    'Your money, beautifully simple',
    Icons.account_balance_outlined,
    Color(0xFFF2D6E2),
    ['Dashboard', 'Subscriptions', 'Transfer money'],
  ),
  Product(
    'illustration',
    'Illustration Shop',
    'A world of little stories',
    Icons.auto_awesome_outlined,
    Color(0xFF558AF8),
    ['Menu', 'Illustrations', 'Popular illustration'],
  ),
  Product(
    'journal',
    'Daily Journal',
    'Small steps to a healthier you',
    Icons.restaurant_outlined,
    Color(0xFFD0F3E6),
    ['Nutrition', 'Breakfast'],
  ),
  Product(
    'finance',
    'Wallet',
    'A clearer view of your finances',
    Icons.credit_card_outlined,
    Color(0xFFD8E2FB),
    ['Wallet', 'Cards & history'],
  ),
  Product(
    'player',
    'Spot Music',
    'A soundtrack for every mood',
    Icons.headphones_outlined,
    Color(0xFF969AA4),
    ['Media library', 'Now playing'],
  ),
  Product(
    'shoe',
    'ShoeShop',
    'Find your next favourite pair',
    Icons.sports_basketball_outlined,
    Color(0xFFF2D6E2),
    ['Collection', 'Air Max 90'],
  ),
  Product(
    'fitness',
    'Fitness Smart',
    'Move well. Feel good.',
    Icons.fitness_center,
    Color(0xFFD8E2FB),
    ['Your health', 'Schedule'],
  ),
  Product(
    'subscription',
    'Your Purchases',
    'Keep the things you love',
    Icons.subscriptions_outlined,
    Color(0xFF969AA4),
    ['Purchases', 'Payment method'],
  ),
];
const screenSlugs = {
  'hydration': ['hydration-home', 'hydration-detail'],
  'drawing': ['drawing-home', 'drawing-detail'],
  'vacancy': ['vacancy-home', 'vacancy-detail'],
  'shop': ['shop-home', 'shop-detail', 'shop-cart'],
  'toothbrush': [
    'toothbrush-home',
    'toothbrush-detail',
    'toothbrush-onboarding',
  ],
  'banking': ['banking-home', 'banking-cards', 'banking-transfer'],
  'illustration': [
    'illustration-home',
    'illustration-detail',
    'illustration-onboarding',
  ],
  'journal': ['journal-home', 'journal-detail'],
  'finance': ['finance-home', 'finance-detail'],
  'player': ['player-home', 'player-detail'],
  'shoe': ['shoe-home', 'shoe-detail'],
  'fitness': ['fitness-home', 'fitness-detail'],
  'subscription': ['subscription-home', 'subscription-detail'],
};
