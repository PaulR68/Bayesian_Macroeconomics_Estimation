# Bayesian_Macroeconomics_Estimation

##  Project Overview
This project analyzes the impact of liquidity constraints on US macroeconomic dynamics through a **Two-Agent Real Business Cycle (RBC)** model. By introducing a fraction of "Hand-to-Mouth" (H-t-M) consumers who spend their entire income each period, we relax the standard representative agent assumption to better capture aggregate consumption volatility.

The model is solved and estimated using **Dynare** and **Matlab**, combining **Simulated Method of Moments (SMM)** for structural calibration and **Bayesian Estimation** for shock dynamics.

##  Key Features
* **Theoretical Framework:** A TANK (Two-Agent New Keynesian) inspired RBC model with flexible prices.
* **Data Strategy:** Uses US data (GDP, Consumption, Interest Rates) from 1952:Q1 to 2023:Q4 (Source: FRED), processed in `data2.csv`.
* **Estimation Methods:**
    * **SMM:** Used to fix the structural "skeleton" (e.g., share of H-t-M agents).
    * **Bayesian:** Used to identify the persistence and volatility of TFP and Government spending shocks.
* **Counterfactual Analysis:** Simulates the economy under varying degrees of financial inclusion.

##  Main Results
1.  **High Liquidity Constraints:** The estimation reveals a significant share of constrained agents (**$\omega \approx 41\%$**).
2.  **Supply vs. Demand:** Output fluctuations are primarily driven by TFP shocks (supply-side), while consumption dynamics are heavily influenced by the financial structure of households.
3.  **Volatility:** A higher share of H-t-M agents drastically amplifies aggregate consumption volatility without significantly affecting output stability.

##  Repository Structure
* `data2.csv` / `data.xlsx`: Pre-processed US macroeconomic dataset (detrended per capita growth rates).
* `SMM.mod` & `SMM_B.mod`: Dynare files for the Simulated Method of Moments estimation.
* `BayesianFinale.mod`: Main Dynare file for the full Bayesian estimation.
* `Test.m`: MATLAB script for counterfactual analysis (simulating different $\omega$ values).
* `Model.mod`: Core model definition file.
* `Report.pdf`: Full project documentation and mathematical derivations.

##  How to Replicate
**Prerequisites:** MATLAB and Dynare (4.x or later).

1.  **Data Preparation:** Ensure `data2.csv` is in the root directory.
2.  **SMM Estimation:** Run `dynare SMM.mod` to obtain structural parameters.
3.  **Bayesian Estimation:** Run `dynare BayesianFinale.mod`. This uses the parameters found in step 2 to estimate shock processes.
4.  **Counterfactuals:** Execute the `Test.m` script in MATLAB to generate volatility tables and analyze the impact of changing the share of spender agents.

---
**Authors:** Gabriel Deregnaucourt, Paul Ritzinger, Alexandre Saint
**Institution:** Université Paris Dauphine - PSL (2026)
