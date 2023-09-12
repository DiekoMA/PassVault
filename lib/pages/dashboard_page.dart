import 'package:flutter/material.dart';
import 'package:passvault/pages/creditcard/credit_cards_homepage.dart';
import 'package:passvault/pages/password/passwords_homepage.dart';
import 'package:passvault/pages/settings_page.dart';
import 'package:passvault/pages/verify_masterpassword_page.dart';
import 'package:passvault/widgets/credit_card_bottomsheet.dart';
import 'package:passvault/widgets/password_bottomsheet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int selectedPageIndex = 0;

  List<String> chipLabels = ["Passwords", "Cards", "Loyalty Cards"];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Pass Vault'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {},
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  value: '/az',
                  child: Text('Alphabetical (a to z)'),
                ),
                PopupMenuItem(
                  value: '/za',
                  child: Text('Alphabetical (z to a)'),
                ),
                PopupMenuItem(
                  value: '/custom',
                  child: Text('Custom'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  ChoiceChip(
                    label: const Text('Password'),
                    selected: selectedPageIndex == 0,
                    onSelected: (selected) {
                      setState(() {
                        selectedPageIndex = selected ? 0 : selectedPageIndex;
                        _pageController.animateToPage(selectedPageIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Cards'),
                    selected: selectedPageIndex == 1,
                    onSelected: (selected) {
                      setState(() {
                        selectedPageIndex = selected ? 1 : selectedPageIndex;
                        _pageController.animateToPage(selectedPageIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  selectedPageIndex = value;
                });
              },
              children: const [
                PasswordsPage(),
                CreditCardsPage(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () {
                showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 380,
                        child: Column(
                          children: <Widget>[
                            const Center(
                              child: Text(
                                'Menu',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            const Text(
                              'Categories',
                              textAlign: TextAlign.left,
                            ),
                            ListTile(
                              title: const Text('Back up'),
                              leading: const Icon(Icons.save),
                              onTap: () {},
                            ),
                            ListTile(
                              title: const Text('Categories'),
                              leading: const Icon(Icons.category),
                              onTap: () {},
                            ),
                            ListTile(
                              title: const Text('Settings'),
                              leading: const Icon(Icons.settings),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsPage()));
                              },
                            ),
                            ListTile(
                              title: const Text('About'),
                              leading: const Icon(Icons.info),
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
            IconButton(
              icon: const Icon(Icons.lock),
              tooltip: 'Lock',
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VerifyMasterPasswordPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              enableDrag: true,
              showDragHandle: true,
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 350,
                  child: Column(
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      ListTile(
                        title: const Text('Password'),
                        leading: const Icon(Icons.password),
                        onTap: () async {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            context: context,
                            builder: (BuildContext context) {
                              return const PasswordBottomSheet();
                            },
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Credit Card'),
                        leading: const Icon(Icons.credit_card),
                        onTap: () {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return const CreditCardBottomSheet();
                              });
                        },
                      ),
                      ListTile(
                        title: const Text('Loyalty Card'),
                        leading: const Icon(Icons.loyalty),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
