abstract class TemplateEvent {
  const TemplateEvent();
}

class InitEvent extends TemplateEvent {
  const InitEvent();
}

class IncrementEvent extends TemplateEvent {
  const IncrementEvent();
}

class DecrementEvent extends TemplateEvent {
  const DecrementEvent();
}
