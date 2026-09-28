import 'dart:io';

void main() {
  final file = File('lib/feature/main_layout/presentation/views/main_layout_view.dart');
  String content = file.readAsStringSync();

  // Find Stack
  final stackStart = content.indexOf('body: Stack(');
  if (stackStart == -1) return;
  
  final stackChildrenStart = content.indexOf('children: [', stackStart);
  final posFillStart = content.indexOf('Positioned.fill(', stackChildrenStart);
  final childStart = content.indexOf('child: AnimatedSwitcher(', posFillStart);
  
  // Extract AnimatedSwitcher
  final animatedSwitcherStart = childStart + 7; // 'AnimatedSwitcher('
  final animatedSwitcherEnd = content.indexOf('),', content.indexOf('child: _buildPage(currentIndex),')) + 2;
  
  final animatedSwitcherCode = content.substring(animatedSwitcherStart, animatedSwitcherEnd);
  
  // Find SafeArea inside Positioned
  final safeAreaStart = content.indexOf('child: SafeArea(', animatedSwitcherEnd);
  final safeAreaEnd = content.indexOf('),', content.indexOf('],', content.indexOf('BootomNavItem', safeAreaStart))) + 2; // end of Row
  // wait, the end of the SafeArea is further down.
  // Let's just find the exact padding code.
  final paddingStart = content.indexOf('child: Padding(', safeAreaStart);
  final paddingEnd = content.indexOf('          ),', content.indexOf('BootomNavItem', paddingStart)) + 12; 
  // It's easier to just find the padding block by relying on the structure.
  
  final bottomNavPaddingStart = content.indexOf('Padding(', safeAreaStart);
  final rowEnd = content.indexOf('],', content.indexOf('BootomNavItem', bottomNavPaddingStart));
  final containerEnd = content.indexOf('),', rowEnd) + 2;
  final paddingBlockEnd = content.indexOf('),', containerEnd) + 2;
  
  final paddingCode = content.substring(bottomNavPaddingStart, paddingBlockEnd);

  final stackEnd = content.indexOf('],', paddingBlockEnd) + 2;
  final finalStackEnd = content.indexOf('),', stackEnd) + 2; // the stack's closing ),
  
  final newBodyAndNav = '''
          body: $animatedSwitcherCode,
          bottomNavigationBar: SafeArea(
            child: $paddingCode
          ),
''';

  content = content.substring(0, stackStart) + newBodyAndNav + content.substring(finalStackEnd);
  
  file.writeAsStringSync(content);
}
