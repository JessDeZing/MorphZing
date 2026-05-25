import 'package:equatable/equatable.dart';

class ContactModel with EquatableMixin {
  final String contactId;
  final String fullName;
  final String initials;
  final String phoneNumber;
  final String rawPhoneNumber;

  const ContactModel({
    required this.contactId,
    required this.fullName,
    required this.initials,
    required this.phoneNumber,
    required this.rawPhoneNumber,
  });

  @override
  List<Object?> get props => [
        contactId,
        fullName,
        initials,
        phoneNumber,
        rawPhoneNumber,
      ];

  @override
  String toString() {
    return 'ContactModel{contactId: $contactId, fullName: $fullName, initials: $initials, phoneNumber: $phoneNumber, rawPhoneNumber: $rawPhoneNumber}';
  }
}
