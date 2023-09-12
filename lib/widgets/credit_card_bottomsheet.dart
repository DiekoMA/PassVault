import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';
import 'package:passvault/Database/database_manager.dart';
import 'package:passvault/models/creditcard.dart';

class CreditCardBottomSheet extends StatefulWidget {
  const CreditCardBottomSheet({super.key});

  @override
  State<CreditCardBottomSheet> createState() => _CreditCardBottomSheetState();
}

class _CreditCardBottomSheetState extends State<CreditCardBottomSheet> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlinedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    final creditCard = CreditCard(
                        cardNumber: int.parse(
                            _cardNumberController.text.replaceAll(' ', '')),
                        cvv: int.parse(_cvvController.text),
                        expirationDate: _expiryDateController.text,
                        ownerName: _ownerNameController.text);
                    await DatabaseManager.instance.insertCard(creditCard);
                    //DatabaseManager.instance.insertPassword(password);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            const Text(
              'Credit Card Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            MaskedTextField(
              controller: _cardNumberController,
              mask: "#### #### #### ####",
              maxLength: 19,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                labelText: 'Card Number',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: MaskedTextField(
                    controller: _expiryDateController,
                    mask: "##/##",
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: MaskedTextField(
                    controller: _cvvController,
                    mask: "###",
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ownerNameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
