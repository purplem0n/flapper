import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../index.dart';

// Helper methods to access Bloc and State from BuildContext
// This allows for cleaner access to the bloc and state in widgets

// instead of using context.read<SampleBloc>()
// you can now use context.sampleBloc
// much easier and faster to write

extension TemplateExt on BuildContext {
  TemplateBloc get templateBloc => read<TemplateBloc>();

  TemplateState get templateState => templateBloc.state;

  void addTemplateEvent(TemplateEvent event) {
    templateBloc.add(event);
  }
}
