path = './lib/presentation/pages/screens/note/note/note_screen.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''      onPopInvoked: (didPop) async {
        if (didPop) return;
        await controller.saveNote(silent: true);
      },'''

new = '''      onPopInvoked: (didPop) {
        if (didPop) return;
        controller.saveNote(silent: true);
      },'''

if old in content:
    content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)
    print('Done')
else:
    print('ERROR: text not found')
