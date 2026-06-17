class LocalSupplier {
  const LocalSupplier({
    required this.id,
    required this.name,
    required this.locality,
    required this.capability,
  });

  final String id;
  final String name;
  final String locality;
  final String capability;
}

abstract final class LocalSuppliersConfig {
  static const List<LocalSupplier> all = [
    LocalSupplier(
      id: 'furnix',
      name: 'Furnix',
      locality: 'Bhaktapur',
      capability: 'Chairs & tables',
    ),
    LocalSupplier(
      id: 'zenspace',
      name: 'Zenspace',
      locality: 'Patan',
      capability: 'Modern seating',
    ),
    LocalSupplier(
      id: 'nordic_co',
      name: 'Nordic Co',
      locality: 'Kathmandu',
      capability: 'Desks & storage',
    ),
    LocalSupplier(
      id: 'harmony',
      name: 'Harmony',
      locality: 'Thamel',
      capability: 'Sofas & lounge',
    ),
    LocalSupplier(
      id: 'forma',
      name: 'Forma',
      locality: 'Pokhara',
      capability: 'Custom woodwork',
    ),
    LocalSupplier(
      id: 'restwell',
      name: 'Restwell',
      locality: 'Lalitpur',
      capability: 'Beds & bedroom',
    ),
    LocalSupplier(
      id: 'gather',
      name: 'Gather',
      locality: 'Baneshwor',
      capability: 'Dining sets',
    ),
    LocalSupplier(
      id: 'lumen',
      name: 'Lumen',
      locality: 'Jawalakhel',
      capability: 'Lighting',
    ),
    LocalSupplier(
      id: 'open_air',
      name: 'OpenAir',
      locality: 'Budhanilkantha',
      capability: 'Outdoor furniture',
    ),
    LocalSupplier(
      id: 'stow',
      name: 'Stow',
      locality: 'Kirtipur',
      capability: 'Storage & decor',
    ),
  ];
}
