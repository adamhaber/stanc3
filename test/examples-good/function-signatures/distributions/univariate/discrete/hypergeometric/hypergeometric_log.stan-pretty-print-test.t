  $ $TESTDIR/../../../../..//../../_build/default/stanc.exe --auto-format "$TESTDIR/../../../../..//function-signatures/distributions/univariate/discrete/hypergeometric/hypergeometric_log.stan"
  data {
    int d_int;
  }
  transformed data {
    real transformed_data_real;
    transformed_data_real <- hypergeometric_log(d_int, d_int, d_int, d_int);
  }
  parameters {
    real y_p;
  }
  transformed parameters {
    real transformed_param_real;
    transformed_param_real <- hypergeometric_log(d_int, d_int, d_int, d_int);
  }
  model {
    y_p ~ normal(0, 1);
  }
  
