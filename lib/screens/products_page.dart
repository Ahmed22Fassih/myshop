import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorite, All }

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var _showOnlyFavorites = false;
  var _isInit = true ;
  var _isLoading = false ;
  
  @override
  void didChangeDependencies(){
    if(_isInit){
     setState(() {
       _isLoading = true ;
     });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false ;
        });
      });
    }
    _isInit =false ;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text("Only Favorite"), value: FilterOptions.Favorite),
              PopupMenuItem(child: Text("Show All"), value: FilterOptions.All)
            ],
          ),
         Consumer<Cart>(
           builder: (_,cart , child) =>  Badge(
             child: child ,
             value: cart.itemCount.toString(),
           ),
           child: IconButton(
             icon: Icon(Icons.shopping_cart),
             onPressed: (){
               Navigator.of(context).pushNamed(CartScreen.routeName);
             },
           ),

         )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ProductsGrid(_showOnlyFavorites),
    );
  }
}
