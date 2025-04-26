import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'model/product.dart';


class ProductDetails extends StatefulWidget {
  final Product? product;
  const ProductDetails({super.key,required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.product!.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              widget.product!.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Tk "+ widget.product!.price!.toString(),
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(widget.product!.description),
          ],
        ),
      ),
    );
  }
}
