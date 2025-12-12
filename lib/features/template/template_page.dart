import 'package:build_when/build_when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../theme/index.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';
import 'index.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  late final bloc = TemplateBloc(context.read<TemplateRepository>());
  late final templateListener = const BlocListenerHelper<TemplateBloc, TemplateState>();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (_) => bloc,
      child: MultiBlocListener(
        listeners: [
          templateListener((state) => state.counter), // automatically shows error toast if error
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.counterAppBarTitle),
            actions: [
              BuildWhen<ThemeBloc, ThemeState>(
                filter: (state) => state.appTheme,
                builder: (context, state) {
                  final icon = switch (state.appTheme) {
                    AppTheme.system => Icons.brightness_auto,
                    AppTheme.light => Icons.light_mode,
                    AppTheme.dark => Icons.dark_mode,
                  };
                  return IconButton(
                    onPressed: () {
                      context.toggleThemeMode();
                    },
                    icon: Icon(icon),
                  );
                },
              ),
            ],
          ),
          body: BuildWhen<TemplateBloc, TemplateState>(
            filter: (state) => state.counter,
            builder: (context, state) {
              return Center(
                child: DisplayLargeText(
                  state.counter.value.toString(),
                  color: scheme.onSurface,
                ),
              );
            },
          ),
          floatingActionButton: BuildWhen<TemplateBloc, TemplateState>(
            filter: (state) => state.counter,
            builder: (context, state) {
              final isLoading = state.counter.isLoading;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: isLoading ? null : () => bloc.add(const IncrementEvent()),
                    child: isLoading ? const CircularLoading() : const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    onPressed: isLoading ? null : () => bloc.add(const DecrementEvent()),
                    child: isLoading ? const CircularLoading() : const Icon(Icons.remove),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
