import 'package:flutter/material.dart';
import 'package:icon_forest/don_icons.dart';
import 'package:icon_forest/iconoir.dart';
import 'package:icon_forest/system_uicons.dart';
import 'package:icon_forest/ternav_icons_duotone.dart';

enum IconFamily {
  material,
  don,
  noir,
  uicons,
  duotone;

  String get name {
    switch (this) {
      case IconFamily.material:
        return 'Material';
      case IconFamily.don:
        return 'Don';
      case IconFamily.noir:
        return 'Noir';
      case IconFamily.uicons:
        return 'Uicons';
      case IconFamily.duotone:
        return 'Duotone';
    }
  }

  Widget get cart {
    switch (this) {
      case IconFamily.material:
        return const Icon(Icons.shopping_cart_outlined);
      case IconFamily.don:
        return const Icon(DonIcons.cart_o);
      case IconFamily.noir:
        return const Iconoir(Iconoir.cart);
      case IconFamily.uicons:
        return const SystemUicons(SystemUicons.cart);
      case IconFamily.duotone:
        return const TernavIconsDuotone(TernavIconsDuotone.cart);
    }
  }

  Widget get home {
    switch (this) {
      case IconFamily.material:
        return const Icon(Icons.home_outlined);
      case IconFamily.don:
        return const Icon(DonIcons.home_o);
      case IconFamily.noir:
        return const Iconoir(Iconoir.home);
      case IconFamily.uicons:
        return const SystemUicons(SystemUicons.home);
      case IconFamily.duotone:
        return const TernavIconsDuotone(TernavIconsDuotone.Home);
    }
  }

  Widget get search {
    switch (this) {
      case IconFamily.material:
        return const Icon(Icons.search_outlined);
      case IconFamily.don:
        return const Icon(DonIcons.search);
      case IconFamily.noir:
        return const Iconoir(Iconoir.search);
      case IconFamily.uicons:
        return const SystemUicons(SystemUicons.search);
      case IconFamily.duotone:
        return const TernavIconsDuotone(TernavIconsDuotone.Search);
    }
  }

  Widget get menu {
    switch (this) {
      case IconFamily.material:
        return const Icon(Icons.menu_outlined);
      case IconFamily.don:
        return const Icon(Icons.menu_outlined);
      case IconFamily.noir:
        return const Iconoir(Iconoir.menu);
      case IconFamily.uicons:
        return const Icon(Icons.menu_outlined);
      case IconFamily.duotone:
        return const TernavIconsDuotone(TernavIconsDuotone.Menu);
    }
  }
}
