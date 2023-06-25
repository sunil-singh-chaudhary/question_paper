// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/Qbloc/question_cubit.dart';
import 'package:question_paper/Qbloc/question_state.dart';
import 'package:question_paper/screen/mcq_screen.dart';
import 'package:question_paper/utils/custom_extension.dart';
import '../services/updated_database_provider.dart';
import '../utils/lotie_animatino_loading.dart';

class QuestionPaper extends StatelessWidget {
  const QuestionPaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QuestionCubit, QuestionState>(
        builder: (context, state) {
          if (state is QuestionInitial) {
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
            return MCQScreen(
              fromwhere: 'server',
            );
          } else if (state is QuestionError) {
            // Handle the error state
            final error = state.error;
            if (Provider.of<GetUpdateDataFromDatabase>(context).hasData) {
              //checking if database has data then show else print erorr
              Provider.of<GetUpdateDataFromDatabase>(context).updatedDataList;

              return MCQScreen(
                fromwhere: 'database',
              ); //if serrver has erro show database data
            } else {
              return Center(
                child: Text(
                  'NO data Found $error',
                  style: const TextStyle().withColorAndSize(Colors.red, 18),
                ), //using extension
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}
