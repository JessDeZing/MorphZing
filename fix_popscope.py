path = './lib/presentation/pages/screens/note/note/note_screen.dart'
with open(path, 'r') as f:
    lines = f.readlines()

scaffold_line = None
for i, line in enumerate(lines):
    if 'return Scaffold(' in line:
        scaffold_line = i
        break

if scaffold_line is None:
    print('ERROR: could not find return Scaffold(')
else:
    lines[scaffold_line] = '    return PopScope(\n      canPop: false,\n      onPopInvoked: (didPop) async {\n        if (didPop) return;\n        await controller.saveNote(silent: true);\n      },\n      child: Scaffold(\n'
    
    for i in range(len(lines)-1, -1, -1):
        if lines[i].strip() == ');':
            lines[i] = '      ),\n    );\n'
            break
    
    with open(path, 'w') as f:
        f.writelines(lines)
    print('Done')
