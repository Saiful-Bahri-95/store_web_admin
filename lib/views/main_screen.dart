import 'package:app_web/views/sidebar_screen/buyers_screen.dart';
import 'package:app_web/views/sidebar_screen/category_screen.dart';
import 'package:app_web/views/sidebar_screen/orders_screen.dart';
import 'package:app_web/views/sidebar_screen/subcategory_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'sidebar_screen/products_screen.dart';
import 'sidebar_screen/upload_banner_screen.dart';
import 'sidebar_screen/vendors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = UploadBannerScreen();

  screenSelector(item) {
    switch (item.route) {
      case BuyersScreen.id:
        setState(() => _selectedScreen = BuyersScreen());
        break;
      case VendorsScreen.id:
        setState(() => _selectedScreen = VendorsScreen());
        break;
      case OrdersScreen.id:
        setState(() => _selectedScreen = OrdersScreen());
        break;
      case CategoryScreen.id:
        setState(() => _selectedScreen = CategoryScreen());
        break;
      case SubcategoryScreen.id:
        setState(() => _selectedScreen = SubcategoryScreen());
        break;
      case UploadBannerScreen.id:
        setState(() => _selectedScreen = UploadBannerScreen());
        break;
      case ProductsScreen.id:
        setState(() => _selectedScreen = ProductsScreen());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 245, 245),
        elevation: 0,
        title: const Text(
          'Admin Management',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 900 ? 12 : 25,
            vertical: 12,
          ),
          child: _selectedScreen,
        ),
      ),

      sideBar: SideBar(
        backgroundColor: Colors.white,
        borderColor: Colors.grey.shade300,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        activeTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),

        header: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 0, 0)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        items: [
          AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: Icons.store_mall_directory,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrdersScreen.id,
            icon: CupertinoIcons.cart_fill,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategoryScreen.id,
            icon: Icons.category_rounded,
          ),
          AdminMenuItem(
            title: 'Subcategories',
            route: SubcategoryScreen.id,
            icon: Icons.device_hub_outlined,
          ),
          AdminMenuItem(
            title: 'Upload Banner',
            route: UploadBannerScreen.id,
            icon: Icons.image_outlined,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductsScreen.id,
            icon: Icons.inventory_2_outlined,
          ),
        ],

        selectedRoute: UploadBannerScreen.id,
        onSelected: (item) => screenSelector(item),
      ),
    );
  }
}
