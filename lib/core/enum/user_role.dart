enum UserRole { customer, business }

extension UserRoleExtension on UserRole {
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'business':
        return UserRole.business;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }
}
