class HomeData {
  final List<BannerItem> bannerOne;
  final List<CategoryItem> categories;
  final List<ProductItem> products;

  HomeData({
    required this.bannerOne,
    required this.categories,
    required this.products,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return HomeData(
      bannerOne: (data['banner_one'] as List)
          .map((e) => BannerItem.fromJson(e))
          .toList(),
      categories: (data['category'] as List)
          .map((e) => CategoryItem.fromJson(e))
          .toList(),
      products: (data['products'] as List)
          .map((e) => ProductItem.fromJson(e))
          .toList(),
    );
  }
}

class BannerItem {
  final String banner;

  BannerItem({required this.banner});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(banner: json['banner']);
  }
}

class CategoryItem {
  final String label;
  final String icon;

  CategoryItem({required this.label, required this.icon});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      label: json['label'],
      icon: json['icon'],
    );
  }
}

class ProductItem {
  final String icon;
  final String offer;
  final String label;
  final String subLabel;

  ProductItem({
    required this.icon,
    required this.offer,
    required this.label,
    required this.subLabel,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      icon: json['icon'],
      offer: json['offer'],
      label: json['label'],
      subLabel: json['SubLabel'] ?? json['Sublabel'] ?? '',
    );
  }
}