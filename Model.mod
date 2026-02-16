// ================================================================
// Project Corrected - Final Working Version (English)
// ================================================================

// 1. Declare variables
var
C       $C$        (long_name='Consumption')
C_SP    $C_SP$     (long_name='Consumption hand-to-mouth')
C_SA    $C_SA$     (long_name='Consumption saver (wealthy)')
L       $L$        (long_name='Labour Hours')
l_sp    $L_SP$     (long_name='Labour hand-to-mouth')
l_sa    $L_SA$     (long_name='Labour saver')
B       $B$        (long_name='Bonds (savings)')
K       $K$        (long_name='Capital')
I       $I$        (long_name='Investment')
W       $W$        (long_name='Wages')
r       $R$        (long_name='Bonds Return')
rK      $rK$       (long_name='Capital Return')
T       $T$        (long_name='Taxes')
Y       $Y$        (long_name='Output')
G       $G$        (long_name='Government Spending')
A       $A$        (long_name='TFP level')
eps_G  $\epsilon^G$  (long_name='Gov Spending Shock process')
// Obs
gy      $gY$       (long_name='Observed GDP Growth %')
gc      $gC$       (long_name='Observed Cons Growth %')
gr      $gR$       (long_name='Observed Interest Rate %')
;

// 2. Declare Exogenous Variables
varexo
eta_A $\eta^A$  (long_name='TFP Shock')
eta_G $\eta^G$ (long_name='Government Spending Shock')
;

// 3. Predetermined Variables
// CORRECTION: Removing B. Only K is a state variable (stock).
// B is a static variable forced to 0.
@#define use_pred_or_not = 1
predetermined_variables K;

// 4. Parameters
parameters
beta  $\beta$     (long_name='Time Discount Factor')
G_bar $\bar{G}$   (long_name='Gov Spending Share of Output')
L_bar $\bar{L}$   (long_name='Steady-State Hours')
sigma $\sigma$    (long_name='Std. Dev. of TFP Shock')
gamma_y $\gamma_y$ (long_name='Growth rate')
delta  $\delta$ (long_name='Depreciation Rate')
alpha  $\alpha$ (long_name='Capital Elasticity ot Output')
rho   $\rho$      (long_name='AR(1) Coefficient for TFP')
omega $\omega$    (long_name='Share of spenders')
rho_G  $\rho_G$ (long_name='AR(1) Persistence of the Shock')
sigma_G $\sigma_G$ (long_name='Std. Dev. of Gov Shock')
;

// 5. Calibration
beta  = 0.995;   
G_bar = 0.2;
L_bar = 1/3;     
sigma = 0.01;
rho   = 0.90;    
delta = 0.025;
alpha = 1/3; 
gamma_y = 1.0036;
omega = 0.3; 
rho_G   = 0.90; 
sigma_G = 0.01;

// 6. Model Section 
model;

// Assumption: Fixed labor supply
l_sp = 1/3;
l_sa = 1/3;

// --- Household Spender (Hand-to-Mouth) ---
[name='FOC: Consumption hand to mouth']
C_SP = W * l_sp - T;

// --- Household Saver ---
[name='FOC: Bonds']
// Note: r is the real rate.
1 / C_SA = (beta / gamma_y) * r / C_SA(+1);

[name='FOC: Investment']
// Capital / Consumption Arbitrage
1 / C_SA = (beta / gamma_y) * (rK(+1) + 1 - delta)/ C_SA(+1);

// --- Market Clearing / Resources ---
// We use the resource constraint to close the model
Y = C + I + G;

// --- Firms ---
[name='FOC: Capital Demand']
// K is predetermined, so K here is the current stock used for production
rK = alpha * Y / K;

[name='FOC: Labour Demand']
W = (1 - alpha) * Y / L;

[name='Production']
Y = A * K^alpha * L^(1-alpha);

[name='AR(1) process of TFP']
log(A) = rho * log(A(-1)) + eta_A;

// --- Government ---
[name='Government Spending Rule']
G = G_bar * Y * eps_G;

[name='AR(1) Gov Spending Shock Process']
log(eps_G) = rho_G * log(eps_G(-1)) + eta_G;

[name='Government Budget']
T = G;

// --- Aggregations & Clearing ---
[name='Labour Market Clearing']
L = omega * l_sp + (1 - omega) * l_sa;

[name='Capital Market Clearing']
// Capital accumulation law
// K(+1) is tomorrow's stock, decided today by investment I
gamma_y * K(+1) = (1 - delta) * K + I;

[name='Bond Market Clearing']
B = 0; 

[name='Aggregate Consumption definition']
C = omega * C_SP + (1 - omega) * C_SA;

// --- OBSERVATION EQUATIONS ---

[name='Observation: GDP Growth']
// In the model: log(Y_t) - log(Y_{t-1}) + log(gamma_y)
// Multiplied by 100 because data in mydata.mat is in %
gy = (log(gamma_y) + log(Y) - log(Y(-1))) * 100;

[name='Observation: Consumption Growth']
gc = (log(gamma_y) + log(C) - log(C(-1))) * 100;

[name='Observation: Interest Rate']
// The model gives r (e.g. 1.01). Data gives dr (e.g. 1.0)
gr = (r - 1) * 100;

end;

// 7. Steady state
steady_state_model;
A = 1;
l_sp = 1/3;
l_sa = 1/3;
L = 1/3;
B = 0;
eps_G = 1;

// Prices
r = gamma_y / beta;
rK = (gamma_y / beta) + delta - 1;

// Output
Y = (alpha / rK)^(alpha / (1 - alpha)) * L;

// Stocks and Flows
K = (alpha / rK) * Y;
I = (gamma_y - (1 - delta)) * K;
G = G_bar * Y * eps_G;
T = G;

// Wages and Consumption
W = (1 - alpha) * Y / L;
C = Y - I - G;

C_SP = W * l_sp - T;
C_SA = (C - omega * C_SP) / (1 - omega);

// Stationary Values of Observables
// At steady state, Y and C grow at rate gamma_y
gy = 100 * log(gamma_y);
gc = 100 * log(gamma_y);
// Net interest rate
gr = 100 * (r - 1);
end;

// 8. Checks and Simulation
steady;
check;
resid;