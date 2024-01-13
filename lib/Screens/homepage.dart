import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol_distributorsga_apps/components/product_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

String accessTok = '';
String refreshTok = '';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  HomeScreen(accessTokFeild, refreshTokFeild) {
    accessTok = accessTokFeild;
    refreshTok = refreshTokFeild;
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  List<String> mainPosterImagesLink = [
    'https://www.101distributorsga.com/images/header/logo.png'
  ];
  var userDetail;
  var firstsliderresult;
  var TagList;
  var catList;
  var defaultCatName;
  List<Widget> widgetList = [];
  String loc = 'Somewhere on the world';
  String cusFullName = 'Guest';
  String cusFirstName = 'Guest';
  String custEmail = 'Guest@email';
  String catName = '';
  int selectedMenuItem = 0;
  List<Widget> menuList = [];
  List<Widget> productListByCat = [];

  final _pageController = PageController(initialPage: 0);
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  _HomeScreenState() {
    getUserDetails(accessTok).then((value) {
      getTopCatList();
      getSliderImages(accessTok);
      getTagList();
    });
  }

  Future<bool> getUserDetails(accTok) async {
    try {
      http.Response res = await http.get(
          Uri.parse('https://dev.salesgent.xyz/api/ecommerce/customer'),
          headers: {
            HttpHeaders.authorizationHeader: accTok,
            'Authorization': 'Bearer $accTok'
          });
      print(res.statusCode);
      if (res.statusCode == 200) {
        var temp = jsonDecode(res.body);
        userDetail = temp['result'];
        if (userDetail['customerDto']['name'] != null) {
          cusFullName = userDetail['customerDto']['name'].toString();
        }
        if (userDetail['customerDto']['firstName'] != null) {
          cusFirstName = userDetail['customerDto']['firstName'].toString();
        }
        if (userDetail['customerDto']['email'] != null) {
          custEmail = userDetail['customerDto']['email'].toString();
        }
        print(userDetail);
        if (userDetail['customerDto']['city'] != null &&
            userDetail['customerDto']['state'] != null &&
            userDetail['customerDto']['county'] != null) {
          loc =
              '${userDetail['customerDto']['city']}, ${userDetail['customerDto']['state']}, ${userDetail['customerDto']['county']}';
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void getTopCatList() async {
    int i = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('https://dev.salesgent.xyz/api/menu'));
      if (res.statusCode == 200) {
        var temp = jsonDecode(res.body);
        catList = temp['result'];
        for (var item in catList) {
          if (i == 0) {
            selectedMenuItem = item['id'];
            defaultCatName = item['name'];
          }
          i++;
        }
      }
    } catch (e) {
      print(e);
    }
    getMenuList();
    setState(() {});
  }

  void getSliderImages(accTok) async {
    int index = 0;
    try {
      http.Response res = await http.get(
          Uri.parse(
              'https://dev.salesgent.xyz/api/home/sliderImages?sliderType=primary&businessTypeId=1&sliderTypeId=89'),
          headers: {
            HttpHeaders.authorizationHeader: accTok,
          });
      if (res.statusCode == 200) {
        var temp = jsonDecode(res.body);
        firstsliderresult = temp['result']['sliderImageList'];
        mainPosterImagesLink.clear();
        for (var v in firstsliderresult) {
          print(v['id']);
          print(v['imageUrl']);
          mainPosterImagesLink.add(v['imageUrl']);
          index++;
        }
        print(mainPosterImagesLink.length);
      }
    } catch (e) {
      print(e);
    }
  }

  void homeProductList() async {
    widgetList.clear();
    for (var ele in TagList) {
      print('test');
      try {
        var tempList;
        http.Response res = await http.get(Uri.parse(
            'https://dev.salesgent.xyz/api/home/product/tagId/${ele['id']}?storeId=2&page=0&size=10&businessTypeId=1'));
        print(res.statusCode);
        if (res.statusCode == 200) {
          var temp = jsonDecode(res.body);
          tempList = temp['result']['content'];
          if (tempList.toString() != '[]') {
            widgetList.add(Text(ele['name'],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                )));
            List<Widget> TL = [];
            print(ele['name']);
            for (var Item in tempList) {
              TL.add(ProductCard(productDetail: Item, onPressed: () {}));
            }
            widgetList.add(SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: TL.map((e) => e).toList(),
              ),
            ));

            widgetList.add(const SizedBox(
              height: 20,
            ));
          }
        }
      } catch (e) {
        print(e);
      }
      setState(() {});
    }
  }

  void getTagList() async {
    try {
      http.Response res = await http
          .get(Uri.parse('https://dev.salesgent.xyz/api/home/productTagList'));
      if (res.statusCode == 200) {
        var temp = jsonDecode(res.body);
        TagList = temp['result'];
        homeProductList();
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildImage(String displayUrl, int indx) => Container(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            displayUrl,
            fit: BoxFit.fill,
          ),
        ),
      );

  void getMenuList() {
    menuList.clear();
    for (var item in catList) {
      menuList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: MaterialButton(
            onPressed: () {
              setState(() {
                selectedMenuItem = item['id'];
                getProductList(selectedMenuItem);
              });
            },
            color: item['id'] == selectedMenuItem ? Colors.amber : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                item['name'],
                style: const TextStyle(
                  color: Color.fromRGBO(97, 106, 125, 1),
                ),
              ),
            ),
          ),
        ),
      );
    }
    getProductList(selectedMenuItem);
    setState(() {});
  }

  void getProductList(int selCID) async {
    int i = 0;
    try {
      http.Response res = await http.get(Uri.parse(
          'https://dev.salesgent.xyz/api/ecommerce/product/category?storeIds=1,2&categoryIdList=$selCID&page=0&size=10&sort=price&sortDirection=DESC'));
      print(res.statusCode);
      if (res.statusCode == 200) {
        productListByCat.clear();
        var temp = jsonDecode(res.body);
        List<Widget> TPL = [];
        for (var item in temp['result']['content']) {
          TPL.add(ProductCard(productDetail: item, onPressed: () {}));
        }
        productListByCat.add(GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 169 / 273,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          children: TPL.map((e) => e).toList(),
        ));
      }
    } catch (e) {
      print(e);
    }
    print('test');
    getMenuList();
    setState(() {});
  }

  static void voiceSearch() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.96,
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.only(top: 30, left: 25, right: 20),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  )),
            ),
            StaggeredGrid.count(
              crossAxisCount: 5,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              children: [
                StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGhLl3gobsf61ooif7wC7W3k41Pf2l6QeWodlR3_E0uA&s',
                        height: 45,
                        width: 45,
                      ),
                    )),
                StaggeredGridTile.fit(
                    crossAxisCellCount: 3,
                    //mainAxisCellCount: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(cusFullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
                    )),
                const StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    //mainAxisCellCount: 3,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Image(
                          image: AssetImage('assets/images/badgeimg.png'),
                          width: 37,
                          height: 40,
                        ))),
                StaggeredGridTile.fit(
                    crossAxisCellCount: 3,
                    //mainAxisCellCount: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(custEmail,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          )),
                    )),
                const StaggeredGridTile.fit(
                    crossAxisCellCount: 3,
                    //mainAxisCellCount: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        value: .8,
                        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
                        valueColor: AlwaysStoppedAnimation(
                            Color.fromRGBO(231, 15, 12, 1)),
                        //color: Color.fromRGBO(231, 15, 12, 1),
                      ),
                    )),
                StaggeredGridTile.fit(
                    crossAxisCellCount: 2,
                    //mainAxisCellCount: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(242, 240, 240, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ))),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit Profile',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.44,
                                ),
                              ),
                              Icon(
                                Icons.person_add_alt_1_outlined,
                                size: 18,
                                color: Color(0xFF616161),
                              )
                            ],
                          )),
                    )),
                StaggeredGridTile.fit(
                    crossAxisCellCount: 2,
                    //mainAxisCellCount: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 7.0, bottom: 1.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(242, 240, 240, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ))),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Settings',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.44,
                                ),
                              ),
                              Icon(
                                Icons.settings_outlined,
                                size: 18,
                                color: Color(0xFF616161),
                              )
                            ],
                          )),
                    )),
              ],
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.person_pin_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'My Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Delivery Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Payment Methods',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.airplane_ticket_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Promo Code',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.question_mark_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Help and Support',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              child: const Row(
                children: [
                  Icon(
                    Icons.login,
                    color: Color.fromRGBO(231, 15, 12, 1),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color.fromRGBO(231, 15, 12, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 20, top: 25),
                color: const Color.fromRGBO(231, 15, 12, 1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text(loc,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white))),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            )),
                        Badge(
                          label: const Text(
                            '0',
                            style: TextStyle(color: Colors.white),
                          ),
                          alignment: const AlignmentDirectional(23, 7),
                          backgroundColor: Colors.amber,
                          child: IconButton(
                              icon: const Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {}),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CarouselSlider.builder(
                itemCount: mainPosterImagesLink.length,
                itemBuilder: (context, index, itemCount) {
                  while (true) {
                    print('cas');
                    print(mainPosterImagesLink.length);
                    print(index);
                    var displayImg = mainPosterImagesLink[index];
                    print(displayImg);
                    return buildImage(displayImg, index);
                  }
                },
                options: CarouselOptions(
                    enableInfiniteScroll: false,
                    height: 187.0,
                    viewportFraction: 0.89,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 10),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: menuList.map((e) => e).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.from(widgetList.map((e) => e)),
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
          ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 18, top: 10),
                color: const Color.fromRGBO(255, 6, 0, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text('Hey, $cusFirstName',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            )),
                        Builder(builder: (context) {
                          return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              tooltip: MaterialLocalizations.of(context)
                                  .openAppDrawerTooltip,
                              icon: const Icon(
                                Icons.format_align_left_outlined,
                                color: Colors.white,
                              ));
                        }),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.document_scanner_outlined,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Badge(
                            label: const Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                            alignment: const AlignmentDirectional(23, 7),
                            backgroundColor: Colors.amber,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [
                        Text('Shop',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w300)),
                        Text(" By Category",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: menuList.map((e) => e).toList(),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: productListByCat.map((e) => e).toList(),
                  )),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 2,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard_outlined,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                    icon: const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ));
              }),
              label: ''),
          BottomNavigationBarItem(
              icon: Container(
                  width: 56,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE60F0C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  )),
              label: ''),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              label: ''),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined, color: Colors.black),
              label: ''),
        ],
        onTap: (index) {
          if (index == 2) {
            _pageController.jumpToPage(0);
          } else if (index == 0) {
            _pageController.jumpToPage(1);
          }
        },
      ),
    );
  }
}
