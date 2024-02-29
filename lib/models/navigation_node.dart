import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NavigationNode extends Equatable {
  NavigationNode({
    required this.title,
    required this.link,
    String? id,
    Iterable<NavigationNode>? children,
  })  : _children = <NavigationNode>[],
        id = id ?? const Uuid().v4() {
    if (children == null) return;

    for (final child in children) {
      child._parent = this;
      _children.add(child);
    }
  }

  /// clone the node and its children
  factory NavigationNode.from(NavigationNode other) {
    final clone = NavigationNode(title: other.title, link: other.link);
    for (final child in other.children) {
      clone._children.add(NavigationNode.from(child));
    }
    return clone;
  }

  /// The number of nodes in the tree.
  int get count => 1 + _children.fold(0, (sum, child) => sum + child.count);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(covariant NavigationNode other) {
    if (identical(this, other)) return true;
    if (title != other.title || link != other.link) return false;
    if (children.length != other.children.length) return false;
    for (var i = 0; i < children.length; i++) {
      if (children[i] != other.children[i]) return false;
    }
    return true;
  }

  factory NavigationNode.empty() => NavigationNode(title: '', link: '');

  /// The fallback value for a navigation tree with cart, checkout, and account
  factory NavigationNode.fallback() => NavigationNode(
        title: 'Root',
        link: '',
        children: [
          NavigationNode(
            title: 'Home',
            link: 'https://www.example.com/home',
            children: [],
          ),
          NavigationNode(
            title: 'Search',
            link: 'https://www.example.com/search',
            children: [],
          ),
          NavigationNode(
            title: 'Cart',
            link: 'https://www.example.com/cart',
            children: [],
          ),
        ],
      );

  String title;
  String link;
  final String id;

  List<NavigationNode> _children;
  List<NavigationNode> get children => _children;

  NavigationNode? _parent;
  NavigationNode? get parent => _parent;

  int get index => _parent?._children.indexOf(this) ?? -1;
  bool get isLeaf => _children.isEmpty;
  bool get isNotLeaf => !isLeaf;
  bool get isRoot => _parent == null;
  bool get isNotRoot => !isRoot;

  // print the tree
  void debugPrintTree([String prefix = '']) {
    debugPrint('$prefix id: $hashCode, parent: ${_parent?.hashCode}');
    for (final child in children) {
      child.debugPrintTree('$prefix  ');
    }
  }

  void insertChild(
    NavigationNode node, {
    int? index,
  }) {
    // if the index is null add to the end
    if (index == null) {
      _children.add(node);
      node._parent = this;
      return;
    }

    // Adjust the index if necessary when dropping a node at the same parent
    if (node._parent == this && node.index < index) {
      index--;
    }

    // Ensure the node is removed from its previous parent and update it
    node
      .._parent?._children.remove(node)
      .._parent = this;

    _children.insert(index, node);
  }

  /// use insertChild to add a sibling to this node
  void addSiblingAfter(NavigationNode sibling) {
    final index = _parent?._children.indexOf(this);
    if (index != null) {
      _parent?.insertChild(
        sibling,
        index: index + 1,
      );
    }
  }

  /// use insertChild to add a sibling before this
  void addSiblingBefore(NavigationNode sibling) {
    final index = _parent?._children.indexOf(this);
    if (index != null) {
      _parent?.insertChild(
        sibling,
        index: index,
      );
    }
  }

  /// Finds the first node in the subtree that matches the predicate
  NavigationNode? find(bool Function(NavigationNode) predicate) {
    if (predicate(this)) return this;
    for (final child in children) {
      final found = child.find(predicate);
      if (found != null) return found;
    }
    return null;
  }

  /// Returns the first parent that matches the predicate
  NavigationNode? findParent(bool Function(NavigationNode) predicate) {
    if (predicate(this)) return this;
    return _parent?.findParent(predicate);
  }

  void remove() {
    _parent?._children.remove(this);
  }

  @override
  List<Object?> get props => [id];
}
