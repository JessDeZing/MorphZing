import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/arguments.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/invitations_controller.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/widgets/invitation_container.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';

class InvitationsScreen extends StatefulWidget {
  final InvitationArguments arguments;

  const InvitationsScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  final controller = Get.put<InvitationsController>(InvitationsController());

  @override
  void initState() {
    super.initState();
    controller.events = RxList(widget.arguments.eventList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StaticAppBar.homeAppBar(
        context,
        widget.arguments.categoryName,
        false,
        '',
      ),
      body: Obx(() {
        return controller.events.isEmpty
            ? const Center(child: Text('No pending events'))
            : Column(
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (_, index) {
                        return InvitationContainer(
                          event: controller.events[index],
                          color: widget.arguments.color,
                          travelPictures: widget.arguments.travelPictures,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: controller.events.length,
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
