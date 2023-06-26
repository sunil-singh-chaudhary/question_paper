// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/Qbloc/question_cubit.dart';
import 'package:question_paper/Qbloc/question_state.dart';
import 'package:question_paper/screen/mcq_screen.dart';
import '../component/retrywidget.dart';
import '../main.dart';
import '../services/updated_database_provider.dart';
import '../utils/internet_service.dart';
import '../utils/lotie_animatino_loading.dart';

class QuestionPaper extends StatelessWidget {
  QuestionPaper({super.key});
  final internetConnectivity = InternetConnectivity();

  @override
  Widget build(BuildContext context) {
    internetConnectivity.startMonitoring(context).then(
          (value) => {
            debugPrint('started monitoring internet in main'),
          },
        );
    return Scaffold(
      body: BlocBuilder<QuestionCubit, QuestionState>(
        // listener: (context, state) {
        //   if (state is QuestionError) {
        //     final error = state.error;
        //     debugPrint(
        //         'error handling state using blocConsumer not Using blocBuilder--> $error');
        //   }
        // },
        builder: (context, state) {
          if (state is QuestionInitial) {
            debugPrint('intial state');

            // Handle the initial state
            return Center(
              child: LottieUtils.loadAnimationFromAsset('assets/loading.json'),
            );
          } else if (state is QuestionLoading) {
            debugPrint('loading state');
            // Handle the loading state
            return Center(
              child: LottieUtils.loadAnimationFromAsset('assets/loading.json'),
            );
          } else if (state is onQuestionLoaded) {
            debugPrint('data Loaded state');
            // Handle the loaded state
            final question = state.question;
            //insert mcq in database using provider
            Provider.of<GetUpdateDataFromDatabase>(context, listen: false)
                .insertData(question);
            return MCQScreen();
          } else if (state is QuestionError) {
            // Handle the error state
            final error = state.error;
            debugPrint('error--> $error');

            if (Provider.of<GetUpdateDataFromDatabase>(context).hasData) {
              // Checking if the database has data, then show it
              Provider.of<GetUpdateDataFromDatabase>(context).updatedDataList;

              return MCQScreen(); // If there's a server error, show the  data from database
            } else {
              return StreamBuilder<ConnectivityResult>(
                stream: internetConnectivity.connectivityStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const RetryWidget();
                    // While the connection status is being determined, show a loading indicator
                  } else if (snapshot.hasData) {
                    // If there is an internet connection, load data from the server
                    debugPrint('internet available');
                    Provider.of<QuestionCubit>(context, listen: false)
                        .fetchQuestionsWebSocket();

                    return Container();
                  } else {
                    debugPrint('internet not available');

                    // If not connected to the internet, display an error message and a retry button
                    return const RetryWidget();
                  }
                },
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}
