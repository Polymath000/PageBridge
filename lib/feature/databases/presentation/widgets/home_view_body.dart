import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/error_widget.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/views/database_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:quicknotion/core/utls/error_widget.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetched) {
      _getDatabases();
      _isFetched = true;
    }
  }

  late List<DatabaseEntity> databases = [];
  void _getDatabases() async {
    final String? token = await SecureStorage.readData(key: tokenKey);
    if (!mounted) return;
    context.read<AddTokenCubit>().addToken(token: token ?? "");
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTokenCubit, AddTokenState>(
      listener: (context, state) {
        if (state is AddTokenSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isLoading = false;
              databases = state.databases;
            });
            // AppRoutes.homeView(context);
          });
        }
      },
      builder: (context, state) {
        if (state is AddTokenLoading) {
          isLoading = true;
        } else if (state is AddTokenFailure) {
          isLoading = false;
          return CustomErrorWidget(errorMessage: state.message);
        }
        return
        // databases.isEmpty
        //     ? ErrorWidget(errorMessage: "There is no databases")
        //     :
        Skeletonizer(
          enabled: isLoading,
          containersColor: AppColors.darkSurface,
          switchAnimationConfig: SwitchAnimationConfig(
            switchOutCurve: Curves.elasticIn,
            switchInCurve: Curves.elasticInOut,
          ),
          child: Column(
            children: databases.map((e) => DatabaseCard(database: e)).toList(),
          ),
        );
      },
    );
  }
}
