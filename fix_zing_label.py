path = './lib/presentation/pages/screens/home/images_widgets/zingrart_image.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''      child: Container(
        height: 150,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: FadeInImage(
          fadeInDuration: 100.milliseconds,
          fadeOutDuration: 100.milliseconds,
          fit: BoxFit.fill,
          placeholderFit: BoxFit.cover,
          placeholder: const AssetImage("assets/images/placeholder_photo.jpg"),
          image: NetworkImage(imageUrl ?? ''),
          imageErrorBuilder: (_, __, ___) => Image.asset(
            "assets/images/placeholder_photo.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),'''

new = '''      child: Container(
        height: 150,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            FadeInImage(
              fadeInDuration: 100.milliseconds,
              fadeOutDuration: 100.milliseconds,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholderFit: BoxFit.cover,
              placeholder: const AssetImage("assets/images/placeholder_photo.jpg"),
              image: NetworkImage(imageUrl ?? ''),
              imageErrorBuilder: (_, __, ___) => Image.asset(
                "assets/images/placeholder_photo.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
                child: const Text(
                  'Zing Photography  ↗',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),'''

if old in content:
    content = content.replace(old, new)
    print('ZingArtImage label added')
else:
    print('ERROR: old block not found')

with open(path, 'w') as f:
    f.write(content)
print('Done')
