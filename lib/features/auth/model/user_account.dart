enum AccountRole { player, owner }

class UserAccount {
  const UserAccount({
    required this.name,
    required this.email,
    this.role = AccountRole.player,
  });

  final String name;
  final String email;
  final AccountRole role;

  bool get isOwner => role == AccountRole.owner;
}
