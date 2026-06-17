path = './lib/presentation/pages/screens/home/home_screen.dart'
with open(path, 'r') as f:
    content = f.read()

old_method = '''  drawerButton(String route, String svg, String title, {double opacity = 1.0}) {'''

new_method = '''  Widget _featureRow({
    required BuildContext context,
    required Widget icon,
    required Color iconBg,
    required String label,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141414) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF222222) : const Color(0xFFE0E0E0),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isDark ? Colors.white : blackTextColor,
                      fontFamily: 'SF Pro Display',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF888888) : const Color(0xFF666666),
                      fontFamily: 'SF Pro Display',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? const Color(0xFF444444) : const Color(0xFFBBBBBB),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  drawerButton(String route, String svg, String title, {double opacity = 1.0}) {'''

if old_method in content:
    content = content.replace(old_method, new_method)
    print('_featureRow method added')
else:
    print('ERROR: drawerButton method not found')

with open(path, 'w') as f:
    f.write(content)
print('File saved')
