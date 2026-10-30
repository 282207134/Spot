"""Package a portable Flutter source project, excluding generated build data."""
from pathlib import Path
import zipfile

root = Path(__file__).resolve().parents[1]
output = root / 'deliverables/Spot-source.zip'
output.parent.mkdir(exist_ok=True)
folders = ['lib', 'assets', 'docs', 'test', 'tool', 'android', 'ios', 'macos']
files = ['README.md', 'pubspec.yaml', 'pubspec.lock', 'analysis_options.yaml', '.metadata', '.gitignore', '.fvmrc']
excluded = {'build', '.dart_tool', '.gradle', '.idea', '.symlinks', 'ephemeral', 'Pods', 'xcuserdata', '.DS_Store', 'local.properties', 'Generated.xcconfig', 'flutter_export_environment.sh'}
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
    candidates = [root / name for name in files]
    for folder in folders:
        candidates.extend((root / folder).rglob('*'))
    for path in sorted(set(candidates)):
        relative = path.relative_to(root)
        if not path.is_file() or path.is_symlink() or excluded.intersection(relative.parts) or path.suffix in {'.iml', '.xcuserstate'}:
            continue
        archive.write(path, Path('Spot') / relative)
print(f'{output.name}: {output.stat().st_size / 1024 / 1024:.1f} MB')
