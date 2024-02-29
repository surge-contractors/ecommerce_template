import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:ecommerce_template/models/bottom_navigation_configuration.dart';
import 'package:ecommerce_template/models/icon_family.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarDelegate extends StatefulWidget {
  const BottomNavigationBarDelegate({
    super.key,
    required this.selectedIndex,
    required this.bottomNavigationConfiguration,
    required this.backgroundColor,
    required this.selectedBackgroundColor,
    required this.foregroundColor,
    required this.selectedForegroundColor,
    required this.iconFamily,
    required this.textStyle,
    this.onIndexSelected,
  });

  final BottomNavigationConfiguration bottomNavigationConfiguration;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color foregroundColor;
  final Color selectedForegroundColor;
  final IconFamily iconFamily;
  final TextStyle textStyle;
  final int selectedIndex;
  final void Function(int)? onIndexSelected;

  @override
  State<BottomNavigationBarDelegate> createState() =>
      _BottomNavigationBarDelegateState();
}

class _BottomNavigationBarDelegateState
    extends State<BottomNavigationBarDelegate> {
  List<TabItem<Widget>> get items => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: widget.iconFamily.home,
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: widget.iconFamily.search,
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: widget.iconFamily.cart,
          label: 'Cart',
        ),
      ]
          .asMap()
          .entries
          .map(
            (e) {
              final index = e.key;
              final icon = ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.selectedIndex == index
                      ? widget.selectedForegroundColor
                      : widget.foregroundColor,
                  BlendMode.srcIn,
                ),
                child: e.value.icon,
              );

              return BottomNavigationBarItem(icon: icon, label: e.value.label);
            },
          )
          .map(
            (e) => TabItem<Widget>(icon: e.icon, title: e.label, key: e.label),
          )
          .toList();

  late final colorScheme = Theme.of(context).colorScheme;
  late final backgroundSelected = Color.alphaBlend(
    colorScheme.primary.withOpacity(0.05),
    colorScheme.surface,
  );
  late final backgroundColor = colorScheme.surface;
  late final color = colorScheme.onSurface;
  late final colorSelected = colorScheme.onSurface;

  @override
  Widget build(BuildContext context) {
    switch (widget.bottomNavigationConfiguration) {
      case BottomNavigationConfiguration.background:
        return BottomBarBackground(
          items: items,
          color: widget.foregroundColor,
          colorSelected: widget.selectedForegroundColor,
          backgroundColor: widget.backgroundColor,
          backgroundSelected: widget.selectedBackgroundColor,
          indexSelected: widget.selectedIndex,
          paddingVertical: 24,
          onTap: widget.onIndexSelected,
          titleStyle: widget.textStyle,
        );
      case BottomNavigationConfiguration.borderTop:
        return BottomBarDivider(
          items: items,
          backgroundColor: widget.backgroundColor,
          color: widget.foregroundColor,
          colorSelected: widget.selectedForegroundColor,
          indexSelected: widget.selectedIndex,
          onTap: widget.onIndexSelected,
          titleStyle: widget.textStyle,
          // styleDivider: StyleDivider.all,
        );
      case BottomNavigationConfiguration.enlarge:
        return BottomBarDefault(
          items: items,
          backgroundColor: widget.backgroundColor,
          color: widget.foregroundColor,
          colorSelected: widget.selectedForegroundColor,
          titleStyle: widget.textStyle,
          indexSelected: widget.selectedIndex,
          onTap: widget.onIndexSelected,
        );
      case BottomNavigationConfiguration.underline:
        return BottomBarInspiredFancy(
          items: items,
          backgroundColor: widget.backgroundColor,
          color: widget.foregroundColor,
          colorSelected: widget.selectedForegroundColor,
          titleStyle: widget.textStyle,
          indexSelected: widget.selectedIndex,
          onTap: widget.onIndexSelected,
        );
      case BottomNavigationConfiguration.dot:
        return BottomBarInspiredFancy(
          items: items,
          backgroundColor: widget.backgroundColor,
          color: widget.foregroundColor,
          colorSelected: widget.selectedForegroundColor,
          styleIconFooter: StyleIconFooter.dot,
          titleStyle: widget.textStyle,
          indexSelected: widget.selectedIndex,
          onTap: widget.onIndexSelected,
        );
      case BottomNavigationConfiguration.floating:
        return Container(
          padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
          child: BottomBarFloating(
            items: items,
            backgroundColor: widget.backgroundColor,
            color: widget.foregroundColor,
            colorSelected: widget.selectedForegroundColor,
            titleStyle: widget.textStyle,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            indexSelected: widget.selectedIndex,
            onTap: widget.onIndexSelected,
          ),
        );
      case BottomNavigationConfiguration.spotlight:
        return BottomBarInspiredInside(
          items: items,
          backgroundColor: widget.backgroundColor,
          color: widget.foregroundColor,
          colorSelected: widget.selectedForegroundColor,
          titleStyle: widget.textStyle,
          animated: false,
          chipStyle: ChipStyle(
            convexBridge: true,
            background: backgroundColor,
            color: backgroundColor,
            notchSmoothness: NotchSmoothness.smoothEdge,
          ),
          itemStyle: ItemStyle.circle,
          indexSelected: widget.selectedIndex,
          onTap: widget.onIndexSelected,
        );
      case BottomNavigationConfiguration.worm:
        return BottomBarSalomon(
          items: items,
          animated: true,
          duration: const Duration(milliseconds: 500),
          titleStyle: widget.textStyle,
          curve: Curves.easeInOutCubicEmphasized,
          colorSelected: widget.selectedForegroundColor,
          color: widget.foregroundColor,
          backgroundColor: widget.backgroundColor,
          backgroundSelected: widget.selectedBackgroundColor,
          indexSelected: widget.selectedIndex,
          onTap: widget.onIndexSelected,
        );
    }
  }
}
