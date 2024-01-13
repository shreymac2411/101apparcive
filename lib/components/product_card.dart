import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  var productDetail;
  Function onPressed;

  ProductCard({required this.productDetail, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      child: Card(
          color: const Color.fromRGBO(251, 248, 248, 1),
          semanticContainer: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: onPressed(),
            child: Container(
              constraints: const BoxConstraints(minWidth: 154, maxWidth: 154, minHeight: 265),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    width: 154,
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border, color: Colors.black,))
                    ),
                  ),
                  Center(
                    child: Stack(
                      //alignment: AlignmentDirectional.topCenter,
                      children: [
                        Image.network(
                          productDetail['imageUrl'] ??
                              'https://www.101distributorsga.com/images/header/logo.png',
                          errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                            return Image.network(
                              'https://www.101distributorsga.com/images/header/logo.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            );
                          },
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: FloatingActionButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              backgroundColor:
                              const Color.fromRGBO(231, 15, 12, 1),
                              onPressed: () {},
                              child: const Icon(Icons.shopping_cart_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                       padding: const EdgeInsets.only(
                         left: 10,
                         right: 10,
                       ),
                       child: Text(productDetail['productName'] ?? '',
                           maxLines: 3,
                           softWrap: true,
                           style: const TextStyle(
                             color: Color(0xFF404040),
                             fontSize: 16,
                             fontWeight: FontWeight.w400,
                           )),
                     ),
                     Container(
                       padding:
                       const EdgeInsets.only(top: 5, left: 10,bottom: 15),
                       child: Text(
                         '\$${productDetail['standardPrice'] ?? '0.0'}',
                         textAlign: TextAlign.left,
                         style: const TextStyle(
                           color: Color(0xFFE60F0C),
                           fontSize: 20,
                           fontWeight: FontWeight.w700,
                         ),
                       ),
                     )
                   ],
                 )
                ],
              ),
            ),
          )),
    );
  }
}
