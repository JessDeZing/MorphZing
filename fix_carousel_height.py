path = './lib/presentation/pages/screens/home/home_screen.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''                        height:
                            ((MediaQuery.of(context).size.width - 32) * 9) / 16,'''

new = '''                        height:
                            ((MediaQuery.of(context).size.width - 32) * 9) / 12,'''

if old in content:
    content = content.replace(old, new)
    print('Carousel height increased')
else:
    print('ERROR: height line not found')

with open(path, 'w') as f:
    f.write(content)
print('Done')
