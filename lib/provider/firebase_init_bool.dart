import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

ValueNotifier<bool> isFirebaseInitialised = ValueNotifier(false);
PersistentTabController persistentTabController = PersistentTabController(initialIndex: 2);
