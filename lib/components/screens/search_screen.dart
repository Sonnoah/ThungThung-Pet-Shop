import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "ค้นหาสินค้า",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 3),
                        child: Icon(Iconsax.search_normal_1, size: 20, color: const Color.fromARGB(192, 158, 158, 158),),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: buildSearchResults(),
      ),
    );
  }

  Widget buildSearchResults() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('catalog').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: Lottie.asset('lottie/FjnPpAsyaW.json'));
      }

      var catalogs = snapshot.data!.docs;

      if (catalogs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('lottie/FjnPpAsyaW.json'),
              Text("ไม่พบสินค้า"),
            ],
          ),
        );
      }


      if (searchQuery.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('lottie/FjnPpAsyaW.json'),
              Text(
                'ค้นหาสินค้า'
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: catalogs.length,
        itemBuilder: (context, index) {
          var catalogId = catalogs[index].id;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('catalog')
                .doc(catalogId)
                .collection('product')
                .snapshots(),
            builder: (context, productSnapshot) {
              if (!productSnapshot.hasData) {
                return Center(child: CircularProgressIndicator(color: Color.fromRGBO(250, 224, 164, 1),));
              }

              var products = productSnapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,  
                itemCount: products.length,
                itemBuilder: (context, productIndex) {
                  var product = products[productIndex].data() as Map<String, dynamic>;

                  if (product['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery)) {

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: ListTile(
                          leading: Image.asset(
                            product['img'], 
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product['name'],
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.justify,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "฿${product['price']}",
                            style: TextStyle(fontSize: 13, color: Color.fromRGBO(228, 95, 43, 1)),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          );
        },
      );
    },
  );
}

}