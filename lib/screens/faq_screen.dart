import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faq = MockData.instance.faq;
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Tire suas dúvidas sobre doação de leite humano',
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 16),
            ...faq.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      iconColor: AppColors.blue,
                      collapsedIconColor: AppColors.textGrey,
                      title: Text(item.question,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.answer,
                              style: const TextStyle(color: AppColors.textGrey, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
