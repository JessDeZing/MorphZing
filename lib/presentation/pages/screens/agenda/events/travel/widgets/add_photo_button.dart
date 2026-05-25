import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/gallery_bottom_sheet.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:photo_gallery/photo_gallery.dart';

class AddPhotoButton extends StatelessWidget {
  final Color color;
  final Function(List<Medium>) onSelectedPhotos;
  final List<Medium> selectedPhotos;

  const AddPhotoButton({
    Key? key,
    required this.color,
    required this.onSelectedPhotos,
    required this.selectedPhotos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width - 60) / 3;
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final result = await GalleryBottomSheet.show(
            context: context,
            color: color,
            selectedPhotos: selectedPhotos,
          );
          if (result != null) {
            onSelectedPhotos(result);
          }
        },
        child: Ink(
          height: size,
          width: size,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/ic_add_photo.svg',
              color: Theme.of(context).iconTheme.color ?? color,
            ),
          ),
        ),
      ),
    );
  }
}
