import 'dart:io';

void main() {
  final file = File('lib/feature/main_layout/presentation/views/main_layout_view.dart');
  String content = file.readAsStringSync();

  // Remove bottomNavigationBar: Padding( ... ), and replace it with a Stack in the body.
  
  // 1. Find the start of AnimatedSwitcher
  final bodyStart = content.indexOf('body: AnimatedSwitcher(');
  final bodyEnd = content.indexOf('),', content.indexOf('child: _buildPage(currentIndex),')) + 2;
  
  final animatedSwitcherCode = content.substring(bodyStart + 6, bodyEnd);
  
  // 2. Find the bottomNavigationBar code
  final bottomNavStart = content.indexOf('bottomNavigationBar: Padding(');
  final bottomNavEnd = content.lastIndexOf('),', content.indexOf('Widget _buildPage')) + 2;
  
  final bottomNavPaddingCode = content.substring(bottomNavStart + 21, bottomNavEnd);
  
  // 3. Reconstruct
  final newBody = '''
          body: Stack(
            children: [
              Positioned.fill(
                child: $animatedSwitcherCode
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: $bottomNavPaddingCode
                ),
              ),
            ],
          ),
''';

  content = content.substring(0, bodyStart) + newBody + content.substring(bottomNavEnd);
  
  file.writeAsStringSync(content);
}
