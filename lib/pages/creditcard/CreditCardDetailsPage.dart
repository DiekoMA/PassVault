import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:passvault/Database/database_manager.dart';
import 'package:passvault/models/creditcard.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCardDetailsPage extends StatefulWidget {
  final CreditCard cardDetails;

  const CreditCardDetailsPage({Key? key, required this.cardDetails})
      : super(key: key);

  @override
  State<CreditCardDetailsPage> createState() => _CreditCardDetailsPageState();
}

class _CreditCardDetailsPageState extends State<CreditCardDetailsPage> {
  bool hideDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardDetails.ownerName!),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: widget.cardDetails.cardNumber.toString(),
              expiryDate: widget.cardDetails.expirationDate!,
              cardHolderName: widget.cardDetails.ownerName!,
              cvvCode: widget.cardDetails.cvv.toString(),
              obscureCardNumber: hideDetails,
              obscureCardCvv: hideDetails,
              showBackView: false,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: hideDetails
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      hideDetails = !hideDetails;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    DatabaseManager.instance.deleteCard(widget.cardDetails.id!);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Card Number'),
              subtitle: Text(widget.cardDetails.cardNumber!.toString()),
              onTap: () async {
                await Clipboard.setData(ClipboardData(
                    text: widget.cardDetails.cardNumber.toString()));
              },
            ),
            ListTile(
              title: const Text('Expiration Date'),
              subtitle: Text(widget.cardDetails.expirationDate!.toString()),
              onTap: () async {
                await Clipboard.setData(ClipboardData(
                    text: widget.cardDetails.expirationDate.toString()));
              },
            ),
            ListTile(
              title: const Text('Cvv'),
              subtitle: Text(widget.cardDetails.cvv!.toString()),
              onTap: () async {
                await Clipboard.setData(
                    ClipboardData(text: widget.cardDetails.cvv.toString()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
