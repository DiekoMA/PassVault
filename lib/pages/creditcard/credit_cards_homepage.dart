import 'package:flutter/material.dart';
import 'package:passvault/Database/database_manager.dart';
import 'package:passvault/models/creditcard.dart';
import 'package:passvault/pages/creditcard/CreditCardDetailsPage.dart';

class CreditCardsPage extends StatefulWidget {
  const CreditCardsPage({super.key});

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  List<CreditCard> cards = [];

  @override
  void initState() {
    super.initState();
    retrieveCards();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void retrieveCards() async {
    final dbManager = DatabaseManager.instance;
    final retrievedCards = await dbManager.getCards();
    setState(() {
      cards = retrievedCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          retrieveCards();
        });
      },
      child: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (BuildContext context, int index) {
          final card = cards[index];

          return ListTile(
            title: Text(card.ownerName!),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          CreditCardDetailsPage(cardDetails: card))));
            },
          );
        },
      ),
    );
  }
}
