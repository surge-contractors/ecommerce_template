import 'dart:ui';

import 'package:ecommerce_template/models/navigation_node.dart';
import 'package:flutter/material.dart';

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({
    required this.root,
    super.key,
  });

  final NavigationNode root;

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            leading: Image.network(
              'https://media.licdn.com/dms/image/C4E0BAQE40Wt5fL0DdQ/company-logo_200_200/0/1630596981972/goodfair1_logo?e=2147483647&v=beta&t=tdcHV_RSMVS64ts1kIkYbV1PbbPpj-M5EvmNW9JkRAM',
              height: 100,
              width: 100,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          AnimatedDrawerItems(
            root: widget.root,
          ),
        ],
      ),
    );
  }
}

class AnimatedDrawerItems extends StatefulWidget {
  const AnimatedDrawerItems({
    required this.root,
    super.key,
  });

  final NavigationNode root;

  @override
  State<AnimatedDrawerItems> createState() => _AnimatedDrawerItemsState();
}

class _AnimatedDrawerItemsState extends State<AnimatedDrawerItems>
    with SingleTickerProviderStateMixin {
  late NavigationNode ptr = widget.root;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 750),
      switchInCurve: const Interval(
        3 / 5,
        1,
        curve: Curves.easeInOutCubicEmphasized,
      ),
      switchOutCurve: const Interval(
        3 / 5,
        1,
        curve: Curves.easeInOutCubicEmphasized,
      ),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);

        return ClipRRect(
          clipBehavior: Clip.hardEdge,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(ptr),
        children: [
          if (ptr.parent != null)
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  // setState(() {
                  //   ptr = ptr.parent!;
                  // });
                },
              ),
              // title: Text(
              //   ptr.parent!.title,
              // ),
            ),
          // AnimatedDrawerList(
          //   duration: const Duration(milliseconds: 1250),
          //   children: List.generate(ptr.children.length, (j) {
          //     return ListTile(
          //       leading: const SizedBox.shrink(),
          //       title: Text(ptr.children[j].title),
          //       trailing: ptr.children[j].children.isEmpty
          //           ? null
          //           : const Icon(Icons.chevron_right),
          //       onTap: () {
          //         setState(() {
          //           ptr = ptr.children[j];
          //         });
          //       },
          //     );
          //   }),
          // ),
        ],
      ),
    );
  }
}

class AnimatedDrawerList extends StatefulWidget {
  const AnimatedDrawerList({
    required this.duration,
    required this.children,
    super.key,
  });

  final Duration duration;
  final List<Widget> children;

  @override
  State<AnimatedDrawerList> createState() => _AnimatedDrawerListState();
}

class _AnimatedDrawerListState extends State<AnimatedDrawerList>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.children.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // fade in each item one by one
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(
                lerpDouble(3 / 5, 4 / 5, index / widget.children.length)!,
                lerpDouble(3 / 5, 1, (index + 1) / widget.children.length)!,
                curve: Curves.easeInOutCubicEmphasized,
              ),
            ),
          ),
          child: widget.children[index],
        );
      },
    );
  }
}
