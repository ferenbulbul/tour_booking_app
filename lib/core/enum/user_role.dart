enum UserRole { customer, driver }

extension UserRoleExtension on UserRole {
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'driver':
        return UserRole.driver;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }
}
