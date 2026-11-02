# Factor prices, returns and bond prices

In the fiscal models, `r`, `w`, `s` and `R` describe different parts of the household's income and saving decision:

| Variable | Meaning |
|---|---|
| `r` | Goods earned during the period by one unit of capital: its rental yield |
| `w` | Goods earned per unit of labour: the real wage |
| `s` | Rental income after capital tax, plus the capital remaining after depreciation |
| `R` | Forward gross return relevant to the consumption Euler equation, including the applicable fiscal wedges |

With one unit of labour, wage income equals `w`. With endogenous labour n, wage income is w*n. A rental yield of 0.08 with depreciation of 0.02 gives a net interest rate of 0.06 and a gross return of 1.06 when taxes and subsidies are zero.

The model calculates these quantities directly in goods units. Their graphs therefore use the variables `r`, `w` and `s` themselves.

## Prices of future consumption: Exercise 5.3.6

Let q_t be the price today of one consumption good received at date t. Set q_0=1. A good received when consumption is plentiful is less valuable than one received when consumption is scarce. Goods received later are also discounted.

For CRRA consumption utility, the solved consumption and tax paths give

\[
q_t=\beta^t(c_t/c_0)^{-\gamma}(1+\tau_{c,0})/(1+\tau_{c,t}).
\]

Here beta is the discount factor, gamma is consumption curvature and tau_c is the consumption tax. The spending experiment keeps the consumption tax constant, so its tax ratio is one.

At date t, a bond delivering one good i periods later costs q_(t+i)/q_t goods. Its continuously compounded yield per period is

\[
y_{i,t}=-\log(q_{t+i}/q_t)/i,\qquad i\geq1.
\]

For example, a one-period bond costing 0.95 goods has gross return 1/0.95 and continuously compounded yield -log(0.95).

The code computes q and the yields after Dynare has solved consumption and capital. No extra price equation is needed in the model block. The yield loop fills one cell per date and maturity; its bounds are given in the comments.
