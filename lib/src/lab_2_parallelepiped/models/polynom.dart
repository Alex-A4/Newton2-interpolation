import 'dart:math';

class Polynomial {
  final double A, B, C, D;

  final double alpha, betta, delta, epsilon, mu;

  final double a, b;

  final int n;

  final double dx;

  final String activeParam;

  double width;

  Polynomial(this.A, this.B, this.C, this.D, this.alpha, this.betta, this.delta,
      this.epsilon, this.mu, this.n, this.a, this.b, this.dx, this.activeParam);

  double fx(double x, double al, double bet, double del, double eps, double m) {
    var divider = pow((x - (m ?? mu)), 2);
    divider = divider < 0.00001 ? 0.00001 : divider;
    return (al ?? alpha) * sin((bet ?? betta) * x) +
        (del ?? delta) * cos((eps ?? epsilon) / divider);
  }

  double integral(double al, double bet, double del, double eps, double m, int n1) {
    double h = (b - a) / n1;
    double rez = 0;
    rez = (fx(a, al, bet, del, eps, m) + fx(b, al, bet, del, eps, m)) / 2;
    for (double x = a + h; x < b; x += h) rez += fx(x, al, bet, del, eps, m);
    for (double x = a; x < b; x += h)
      rez += 2 * fx((x + x + h) / 2, al, bet, del, eps, m);
    rez *= (h / 3);
    return rez;
  }

  @override
  String toString() =>
      'A:$A, B:$B, C:$C, D:$D, aplha:$alpha, betta:$betta, delta:$delta, '
      'epsilon:$epsilon, mu:$mu, n:$n';
}
