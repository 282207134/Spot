"""Rebuild the Markdown screen index and contact sheets. Requires Pillow."""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
DATA = json.loads((ROOT / 'docs/design/source-map.json').read_text())
GROUPS = [
    ('hydration', 'Hydra · 饮水健康', ['home', 'detail']),
    ('drawing', 'Drawi · 绘画教程', ['home', 'detail']),
    ('vacancy', 'Job Seeker · 求职', ['home', 'detail']),
    ('shop', 'The Top Shop · 服饰商城', ['home', 'detail', 'cart']),
    ('toothbrush', 'T-Brush · 电动牙刷', ['home', 'detail', 'onboarding']),
    ('banking', 'Everyday Bank · 银行', ['home', 'cards', 'transfer']),
    ('illustration', 'Illustration Shop · 插画商城', ['home', 'detail', 'onboarding']),
    ('journal', 'Daily Journal · 营养日记', ['home', 'detail']),
    ('finance', 'Wallet · 钱包', ['home', 'detail']),
    ('player', 'Spot Music · 音乐', ['home', 'detail']),
    ('shoe', 'ShoeShop · 鞋店', ['home', 'detail']),
    ('fitness', 'Fitness Smart · 健身', ['home', 'detail']),
    ('subscription', 'Your Purchases · 订阅购买', ['home', 'detail']),
]
NAMES = {'home': '首页', 'detail': '详情', 'cart': '订单确认', 'cards': '订阅历史', 'transfer': '转账', 'onboarding': '商品详情'}
SOURCES = {item['slug']: item for item in DATA['screens']}
ORDER = [f'{prefix}-{suffix}' for prefix, _, suffixes in GROUPS for suffix in suffixes]
FONT = ImageFont.truetype(str(ROOT / 'assets/fonts/Inter.ttf'), 11)
TITLE = ImageFont.truetype(str(ROOT / 'assets/fonts/Inter.ttf'), 25)

def contact_sheet(folder, destination, title):
    width, height = 190, 435
    sheet = Image.new('RGB', (6 * width, 5 * height + 65), '#F0F2F6')
    draw = ImageDraw.Draw(sheet)
    draw.text((18, 15), title, font=TITLE, fill='#10182B')
    for index, slug in enumerate(ORDER):
        image = Image.open(ROOT / folder / f'{slug}.png').convert('RGB')
        image.thumbnail((175, 395), Image.Resampling.LANCZOS)
        x, y = index % 6 * width, index // 6 * height + 65
        sheet.paste(image, (x + (width - image.width) // 2, y))
        draw.text((x + 8, y + 404), f'{index + 1:02}  {slug}', font=FONT, fill='#30384A')
    sheet.save(ROOT / destination, quality=90, optimize=True)

contact_sheet('docs/screenshots', 'docs/screens-overview.jpg', 'Spot / Flutter / 13 collections / 30 screens')
contact_sheet('docs/design/reference', 'docs/design/contact-sheet.jpg', 'Spot / Pixso reference / 30 screens')

lines = ['# 全部界面与原稿对照', '', '[返回项目说明](../README.md)', '',
         '共 13 类、30 个业务界面。左侧为 Pixso 原稿，右侧为 Flutter 原生控件渲染截图。', '',
         '短文件名中的 `home/detail/onboarding` 仅为稳定的截图标识；具体页面职责以应用内页名为准。', '',
         '![全部界面总览](screens-overview.jpg)', '']
for prefix, title, suffixes in GROUPS:
    lines += [f'## {title}', '', '| 页面标识 / Pixso 节点 | 参考稿 | Flutter 实现 |', '| --- | --- | --- |']
    for suffix in suffixes:
        slug = f'{prefix}-{suffix}'
        source = SOURCES[slug]
        lines.append(f'| `{slug}`<br>节点 `{source["nodeId"]}` | <img src="design/reference/{slug}.png" width="170" alt="{slug} 原稿"> | <img src="screenshots/{slug}.png" width="170" alt="{slug} Flutter 实现"> |')
    lines.append('')
lines += ['## 设计规范', '', 'Styles 页面中的两个规范板已另存为截图：', '',
          '- [配色规范](design/reference/style-colors.png)', '- [字体规范](design/reference/style-typography.png)', '',
          'Symbols 页面包含 104 个基础组件，项目在共享组件层实现对应的页头、按钮、输入框、导航和图表等角色。', '']
(ROOT / 'docs/SCREENS.md').write_text('\n'.join(lines))
print('Created 2 contact sheets and docs/SCREENS.md for 30 screens.')
