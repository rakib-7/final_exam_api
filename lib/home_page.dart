import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api/api.dart';
import 'model/product.dart';
import 'product_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Product>> getProducts() async {
    List<Product> products = [];

    try {
      final url = Uri.parse(Api.getProductsUrl);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        for (var eachProduct in responseData as List) {
          products.add(Product.fromJson(eachProduct));
        }
      } else {
        Fluttertoast.showToast(msg: "Error fetching products");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: errorMsg.toString());
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products", style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Product>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Failed to load products'));
          }

          final products = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.60,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),

              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetails(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Tk ${product.price}",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    backgroundColor: Colors.blue,
                                  ),
                                    onPressed: (){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${product.title} added to cart'),),
                                    );
                                    },
                                    child: const Center( child: Text('Add to Cart', style: TextStyle(fontSize: 13,),
                                    textAlign: TextAlign.center,
                                    ),),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    backgroundColor: Colors.grey,
                                  ),
                                    onPressed: (){
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (_)=> ProductDetails(product: product),),

                                    );
                                    },
                                    child: const Text('Details',style: TextStyle(fontSize: 12),),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
