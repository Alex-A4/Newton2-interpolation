import 'dart:math';

class Polynomial {
  final double A, B, C, D;

  final double alpha, betta, delta, epsilon, mu;

  final double step, h;

  final List<List<double>> dy;

  final int n;

  Polynomial(this.A, this.B, this.C, this.D, this.alpha, this.betta, this.delta,
      this.epsilon, this.mu, this.n, this.h)
      : this.step = (B - A) / (2 * n + 1),
        this.dy = List.generate(
          2 * n + 2,
          (index) => List.generate(2 * n + 2, (index) => null),
        ) {
    for (int i = 0; i < 2 * n + 2; i++) {
      dy[0][i] = fx(A + i * step);
    }

    for (int i = 1; i < 2 * n + 2; i++) {
      for (int j = 0; j < 2 * n + 2 - i; j++)
        dy[i][j] = dy[i - 1][j + 1] - dy[i - 1][j];
    }
  }

  double pn(double x) {
    int i;
    double x0, sum, p, q;

    p = 1;
    x0 = A + n * (B - A) / (2 * n + 1);
    q = (x - x0) * (2 * n + 1) / (B - A);
    sum = (dy[0][n] + dy[0][n + 1]) / 2;
    sum = sum + (q - 0.5) * dy[1][n];

    for (i = 1; i < n + 1; i++) {
      p = p * (q + i - 1) * (q - i) / (2 * i);
      sum = sum + p * (dy[2 * i][n - i] + dy[2 * i][n - i + 1]) / 2;
      p = p / (2 * i + 1);
      sum = sum + (q - 0.5) * p * dy[2 * i + 1][n - i];
    }

    return sum;
  }

  double fx(double x) {
    var divider = pow((x - mu), 2);
    divider = divider < 0.00001 ? 0.00001 : divider;
    return alpha * sin(betta * x) + delta * cos(epsilon / divider);
  }

  void printDy() {
    for (int i = 0; i < dy.length; i++) {
      var str = '';
      for (int j = 0; j < dy[i].length; j++) str += '${dy[i][j]} ';
      print(str);
    }
  }

  @override
  String toString() =>
      'A:$A, B:$B, C:$C, D:$D, aplha:$alpha, betta:$betta, delta:$delta, '
      'epsilon:$epsilon, mu:$mu, n:$n, h:$h';
}
