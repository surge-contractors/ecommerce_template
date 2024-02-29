import 'dart:math';
import 'package:ecommerce_template/models/bottom_navigation_configuration.dart';
import 'package:ecommerce_template/models/drawer_configuration.dart';
import 'package:ecommerce_template/models/icon_family.dart';
import 'package:ecommerce_template/widgets/bottom_navigation_delegate.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:ecommerce_template/models/navigation_configuration.dart';
import 'package:ecommerce_template/models/navigation_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

export 'package:ecommerce_template/models/bottom_navigation_configuration.dart';
export 'package:ecommerce_template/models/drawer_configuration.dart';
export 'package:ecommerce_template/models/icon_family.dart';
export 'package:ecommerce_template/models/navigation_configuration.dart';
export 'package:ecommerce_template/models/navigation_node.dart';

/// This class wraps the ecom view and provides it a managed state object
class ManagedEcomView extends StatefulWidget {
  const ManagedEcomView({
    super.key,
    required this.navigation,
    this.colorScheme = const ColorScheme.light(),
    this.navigationConfiguration = NavigationConfiguration.bottom,
    this.drawerConfiguration = DrawerConfiguration.backdrop,
    this.bottomNavigationConfiguration = BottomNavigationConfiguration.worm,
    this.iconFamily = IconFamily.material,
    this.textStyle = const TextStyle(),
    this.fullLogo = const SizedBox.shrink(),
    this.squareLogo = const SizedBox.shrink(),
  });

  final ColorScheme colorScheme;
  final NavigationConfiguration navigationConfiguration;
  final DrawerConfiguration drawerConfiguration;
  final BottomNavigationConfiguration bottomNavigationConfiguration;
  final IconFamily iconFamily;
  final TextStyle textStyle;
  final Widget fullLogo;
  final Widget squareLogo;
  final NavigationNode navigation;

  @override
  State<ManagedEcomView> createState() => _ManagedEcomViewState();
}

class _ManagedEcomViewState extends State<ManagedEcomView> {
  final advancedDrawerController = AdvancedDrawerController();
  final zoomDrawerController = ZoomDrawerController();
  var bottomNavigationIndex = 0;
  late var currentNavigationNode = widget.navigation;

  @override
  Widget build(BuildContext context) {
    return EcomView(
      colorScheme: widget.colorScheme,
      navigationConfiguration: widget.navigationConfiguration,
      drawerConfiguration: widget.drawerConfiguration,
      bottomNavigationConfiguration: widget.bottomNavigationConfiguration,
      iconFamily: widget.iconFamily,
      textStyle: widget.textStyle,
      fullLogo: widget.fullLogo,
      squareLogo: widget.squareLogo,
      bottomNavigationIndex: bottomNavigationIndex,
      onBottomNavigationIndexSelected: (index) {
        setState(() {
          bottomNavigationIndex = index;
        });
      },
      currentNavigationNode: currentNavigationNode,
      onCurrentNavigationNodeChanged: (p0) => setState(() {
        currentNavigationNode = p0;
      }),
      drawerPosition: 0,
      onDrawerToggle: () {
        advancedDrawerController.toggleDrawer();
        zoomDrawerController.toggle?.call();
      },
    );
  }
}

class EcomView extends StatelessWidget {
  const EcomView({
    required this.currentNavigationNode,
    this.view,
    this.onCurrentNavigationNodeChanged,
    super.key,
    this.colorScheme = const ColorScheme.light(),
    this.navigationConfiguration = NavigationConfiguration.bottom,
    this.drawerConfiguration = DrawerConfiguration.backdrop,
    this.bottomNavigationConfiguration = BottomNavigationConfiguration.worm,
    this.iconFamily = IconFamily.material,
    this.textStyle = const TextStyle(),
    this.fullLogo = const SizedBox.shrink(),
    this.squareLogo = const SizedBox.shrink(),
    this.bottomNavigationIndex = 0,
    this.onBottomNavigationIndexSelected,
    this.drawerPosition = 0.0,
    this.onDrawerToggle,
  });

  /// The color scheme for the application. Used to render the background and
  /// foreground colors.
  final ColorScheme colorScheme;

  /// The configuration for the navigation. Defaults to bottom which shows the
  /// bottom navigation bar.
  final NavigationConfiguration navigationConfiguration;

  /// The configuration for the bottom navigation bar. Defaults to background
  /// which moves the screen to the right and shows the drawer content
  /// underneath.
  final DrawerConfiguration drawerConfiguration;

  /// The appearance of the bottom navigation bar. Defaults to worm which has
  /// an implicit animation.
  final BottomNavigationConfiguration bottomNavigationConfiguration;

  /// The icon family to use for the navigation features. Defaults to Material
  /// which is the default icon theme for Flutter.
  final IconFamily iconFamily;

  /// The text style to use for the application. Defaults to the default text
  /// style for Flutter.
  final TextStyle textStyle;

  /// The logo to use for the application.
  final Widget fullLogo;

  /// The square logo to use for the application.
  final Widget squareLogo;

  /// The initial navigation node to use for the application.
  final NavigationNode currentNavigationNode;

  /// Called when the current navigation node changes
  final void Function(NavigationNode)? onCurrentNavigationNodeChanged;

  /// The currently selected bottom navigation index
  final int bottomNavigationIndex;

  /// Called when the bottom navigation index is selected.
  final void Function(int)? onBottomNavigationIndexSelected;

  /// The position of the drawer. Defaults to 0.0 which is the closed position.
  final double drawerPosition;

  /// Called when the drawer is toggled.
  final void Function()? onDrawerToggle;

  /// The body: if provided, it will be used as the body of the scaffold
  /// and no navigational elements will be used in determining the body.
  final Widget? view;

  List<Widget>? get actions {
    if (navigationConfiguration != NavigationConfiguration.appbar) {
      return null;
    }

    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.shopping_cart),
        onPressed: () {},
      ),
    ];
  }

  Widget? get drawer {
    switch (drawerConfiguration) {
      case DrawerConfiguration.tilted:
        return null;
      case DrawerConfiguration.slide:
        return Drawer(
          elevation: 0,
          backgroundColor: colorScheme.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: drawerContent,
        );
      case DrawerConfiguration.backdrop:
        return null;
    }
  }

  int nearestPowerOfTwo(int n) {
    // Edge case for 0 or negative numbers
    if (n <= 1) {
      return 1;
    }

    // Calculate the floor log base 2 of n
    int lowerPower = log(n) ~/ log(2);

    // Calculate the two closest powers of two
    num lower = pow(2, lowerPower);
    num higher = pow(2, lowerPower + 1);

    // Determine which is closer to n
    if ((n - lower) < (higher - n)) {
      return lower.toInt();
    } else {
      return higher.toInt();
    }
  }

  static Widget webview({required String link}) {
    final String websiteUrl = Uri.encodeComponent(
      link,
    ); // Ensure the URL is properly encoded

    // Calculate nearest power of two for width
    const int newWidth = 256;

    // Calculate the original aspect ratio (width / height)
    // final double aspectRatio = constraints.maxWidth / constraints.maxHeight;

    // Calculate the new height based on the aspect ratio and new width
    final int newHeight = 1920;

    final String screenshotUrl =
        'http://localhost:8080/on_generate_website_screenshot?url=$websiteUrl&width=$newWidth&height=$newHeight';
    print(screenshotUrl);
    final controller = ScrollController();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
            child: Image.network(
              screenshotUrl,
              width: constraints.maxWidth,
              fit: BoxFit.fitWidth,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
            ),
          ),
        );
      },
    );
  }

  Widget? get body {
    final child =
        view == null ? webview(link: currentNavigationNode.link) : view!;
    switch (navigationConfiguration) {
      case NavigationConfiguration.bottom:
      case NavigationConfiguration.appbar:
      case NavigationConfiguration.drawer:
        return child;
      case NavigationConfiguration.rail:
        return Row(
          children: [
            NavigationRail(
              backgroundColor: colorScheme.surface,
              onDestinationSelected: onBottomNavigationIndexSelected,
              destinations: [
                NavigationRailDestination(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    child: iconFamily.menu,
                  ),
                  label: Text(
                    "Menu",
                    style: textStyle,
                  ),
                ),
                NavigationRailDestination(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    child: iconFamily.home,
                  ),
                  label: Text('Home', style: textStyle),
                ),
                NavigationRailDestination(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    child: iconFamily.search,
                  ),
                  label: Text('Search', style: textStyle),
                ),
                NavigationRailDestination(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    child: iconFamily.cart,
                  ),
                  label: Text('Cart', style: textStyle),
                ),
              ],
              selectedIndex: bottomNavigationIndex,
            ),
            Expanded(child: child),
          ],
        );
    }
  }

  PreferredSizeWidget? get appBar {
    switch (navigationConfiguration) {
      case NavigationConfiguration.rail:
        return null;
      case NavigationConfiguration.bottom:
      case NavigationConfiguration.appbar:
      case NavigationConfiguration.drawer:
        return AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              onDrawerToggle?.call();
            },
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          title: SizedBox(
            height: 60,
            child: AspectRatio(aspectRatio: 3 / 2, child: fullLogo),
          ),
          centerTitle: true,
          actions: actions,
        );
    }
  }

  Widget wrapWithDrawer({
    required Widget child,
    required BuildContext context,
  }) {
    switch (drawerConfiguration) {
      case DrawerConfiguration.backdrop:
        return AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
            ),
          ),
          controller: AdvancedDrawerController(),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: true,
          drawer: drawerContent,
          child: child,
        );
      case DrawerConfiguration.tilted:
        return ZoomDrawer(
          menuScreen: drawerContent,
          menuBackgroundColor: colorScheme.surface,
          mainScreen: child,
          controller: ZoomDrawerController(),
          borderRadius: 24.0,
          showShadow: true,
          angle: -12.0,
          disableDragGesture: true,
          slideWidth: Theme.of(context).drawerTheme.width ?? 275.0,
          openCurve: Curves.easeInOutCubicEmphasized,
          closeCurve: Curves.easeInOutCubicEmphasized,
          mainScreenTapClose: true,
        );
      case DrawerConfiguration.slide:
        return child;
    }
  }

  Widget get drawerContent {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentNavigationNode.parent != null)
              ListTile(
                title: Text(
                  currentNavigationNode.title,
                  style: textStyle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                leading: const Icon(Icons.chevron_left),
                onTap: () => onCurrentNavigationNodeChanged?.call(
                  currentNavigationNode.parent!,
                ),
              ),
            ...List.generate(
              currentNavigationNode.children.length,
              (index) {
                final node = currentNavigationNode.children[index];
                return ListTile(
                  title: Text(
                    node.title,
                    style: textStyle.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  trailing:
                      node.isNotLeaf ? const Icon(Icons.chevron_right) : null,
                  onTap: () => onCurrentNavigationNodeChanged?.call(node),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget? get bottomNavigationBar {
    switch (navigationConfiguration) {
      case NavigationConfiguration.appbar:
      case NavigationConfiguration.drawer:
      case NavigationConfiguration.rail:
        return null;
      case NavigationConfiguration.bottom:
        return BottomNavigationBarDelegate(
          selectedIndex: bottomNavigationIndex,
          onIndexSelected: onBottomNavigationIndexSelected,
          iconFamily: iconFamily,
          textStyle: textStyle,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          selectedBackgroundColor: colorScheme.primary,
          selectedForegroundColor: colorScheme.onPrimary,
          bottomNavigationConfiguration: bottomNavigationConfiguration,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      drawer: drawer,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );

    child = wrapWithDrawer(child: child, context: context);

    return child;
  }
}
