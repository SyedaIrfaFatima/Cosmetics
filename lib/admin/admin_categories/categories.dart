import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosme/admin/admin_categories/sub%20_catogries.dart';

import 'package:cosme/utils/color.dart';
import 'package:cosme/widget/text%20and%20icon/big_text.dart';
import 'package:flutter/material.dart';

// class Categories extends StatefulWidget {
//   const Categories({Key? key}) : super(key: key);
//
//   @override
//   State<Categories> createState() => _CategoriesState();
// }
//
// class _CategoriesState extends State<Categories> {
//   var myList = <String>[];
//   List<String> items = List<String>.generate(20, (i) => "items   $i");
//

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Catagories"),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 20),
//             margin: EdgeInsets.only(left: 20),
//             width: 300,
//             height: 50,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: Colors.grey[100]),
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 10,
//                 ),
//                 AppIcon(
//                   icon: Icons.search,
//                   background: Colors.white,
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 SmallText(
//                   text: 'Search Product',
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final item = items[index];
//                 return Dismissible(
//                     key: Key(item),
//                     direction: DismissDirection.endToStart,
//                     background: const Card(
//                       color: Colors.red,
//                       margin: EdgeInsets.only(
//                         left: 200,
//                       ),
//                       child: Icon(
//                         Icons.delete,
//                       ),
//                     ),
//                     onDismissed: (direction) {
//                       setState(() {
//                         items.removeAt(index);
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: 400,
//                         child: ListTile(
//                           onTap: () {
//                             print(index);
//                           },
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 width: 250,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   color: Colors.pinkAccent,
//                                 ),
//                                 child: Text(
//                                   items[index],
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 25,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () {
//                                   // Handle edit action here
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ));
//               },
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // _addItemToFirebase();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String selecteditem = '';
  var myList = <String>[];
  List<String> MainProductDataList = [];
  // List<String> items = List<String>.generate(20, (i) => "items   $i");
  TextEditingController regionNameController = TextEditingController();

  Future<void> _fetchProduct() async {
    final productquery =
        await FirebaseFirestore.instance.collection('Product').get();

    setState(() {
      MainProductDataList = productquery.docs.map((doc) => doc.id).toList();
    });
    print("My Debug: $MainProductDataList");
  }

  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Product')
          .doc(productId)
          .delete();

      setState(() {
        MainProductDataList.remove(productId);
      });
    } catch (e) {
      print('Error deleting product');
    }
  }

  Future<void> addProduct(String itemName) async {
    //check if the region name already exist in regionDatalist
    if (MainProductDataList.contains(itemName)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(' name already exists'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return;
    }
    // Define a regular expression pattern to match only alphabets and spaces
    final RegExp alphabetsPattern = RegExp(r'^[A-Za-z\s]+$');
    if (!alphabetsPattern.hasMatch(itemName)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Catogeries name should consist of alphabets. number and special character  are not allowed'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function if the constraint is not met
    }

    try {
      await FirebaseFirestore.instance.collection('Product').doc(itemName).set({
        'name': itemName,
        // You can add more fields if needed
      });

      // Add the new region to the UI
      setState(() {
        MainProductDataList.add(itemName);
      });

      // Clear the text field after adding the region
      regionNameController.clear();
      // Show a success message using AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Product added successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors here.
      print('Error adding region: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Column(children: [
              BigText(text: 'Catogeris'),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: regionNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Product name',
                ),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: MainProductDataList.length,
              itemBuilder: (BuildContext context, int index) {
                final itemName = MainProductDataList[index];
                return Dismissible(
                    key: Key(itemName),
                    direction: DismissDirection.endToStart,
                    background: const Card(
                      color: Colors.red,
                      margin: EdgeInsets.only(
                        left: 200,
                      ),
                      child: Icon(
                        Icons.delete,
                      ),
                    ),
                    onDismissed: (direction) {
                      String productId = MainProductDataList[index];
                      print("Deleting product Id :$productId");
                      deleteProduct(productId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 400,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubCatogeries(
                                  selectproducts: itemName,
                                ),
                              ),
                            );
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 250,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColor.mainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    MainProductDataList[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit action here
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          String itemName = regionNameController.text.trim();
          if (itemName.isNotEmpty) {
            addProduct(itemName);
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
