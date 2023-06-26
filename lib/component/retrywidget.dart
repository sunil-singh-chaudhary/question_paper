import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Qbloc/question_cubit.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Retrying...'),
                      ],
                    ),
                  );
                },
              );

              try {
                Provider.of<QuestionCubit>(context, listen: false)
                    .fetchQuestionsWebSocket();

                // Close the progress dialog after 3 seconds
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
              } catch (error) {
                // Handle any error that occurred during the retry
                Navigator.of(context).pop(); // Close the progress dialog
                debugPrint('Error occurred while retrying: $error');
              }
            },
            child: const Text('Retry'),
          ),
          const Text('No internet connection available'),
        ],
      ),
    );
  }
}
