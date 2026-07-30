enum ScreeningDomain { jointAttention, pretendPlay, socialInterest, repetitiveBehavior }

extension ScreeningDomainX on ScreeningDomain {
  String get label {
    switch (this) {
      case ScreeningDomain.jointAttention:
        return 'Joint attention';
      case ScreeningDomain.pretendPlay:
        return 'Pretend play';
      case ScreeningDomain.socialInterest:
        return 'Social interest';
      case ScreeningDomain.repetitiveBehavior:
        return 'Repetitive behavior';
    }
  }
}
