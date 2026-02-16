// ===============================================================
// PROJET FINAL - ESTIMATION BAYESIENNE
// ===============================================================



// 2. On inclut ton modèle complet
@#include "Model.inc"
// 1. On déclare les variables observées (Dynare en a besoin ici)
varobs gy gc;
// 3. CALIBRATION : ON ECRASE AVEC TES RESULTATS SMM
// Dynare prendra ces valeurs-là au lieu de celles dans Model.inc
beta    = 0.998;     // Ta valeur fixée
gamma_y = 1.0043;    // Ton estimation SMM
omega   = 0.4084;    // Ton estimation SMM

// Initialisation des chocs (valeurs de départ pour l'algo Bayésien)
rho     = 0.90;      // Persistance TFP
rho_G   = 0.90;      // Persistance Gouv
sigma   = 0.01;      // Volatilité TFP
sigma_G = 0.01;      // Volatilité Gouv

// Vérification
steady;
check;

// 4. BLOC D'ESTIMATION
estimated_params;
    // On estime les persistances (rho)
    // ATTENTION aux noms : dans ton Model.inc c'est 'rho' pour la TFP, pas 'rho_A'
    rho,          0.90, 0.01, 0.999, beta_pdf,      0.70, 0.20;
    rho_G,        0.90, 0.01, 0.999, beta_pdf,      0.70, 0.20;
    
    // On estime les écarts-types des chocs (varexo)
    stderr eta_A, 0.01, 0.0001, 5.0, inv_gamma_pdf, 0.01, 2.0;
    stderr eta_G, 0.01, 0.0001, 5.0, inv_gamma_pdf, 0.01, 2.0;
end;

// 5. PREPARATION DES DONNEES (Infaillible)
verbatim;
    % On lit le CSV
    ds_temp = dseries('data2.csv');
    % On extrait les données brutes
    gy = ds_temp.gy.data;
    gc = ds_temp.gc.data;
    % On sauvegarde dans un format que Dynare adore (variables simples)
    save('dataset_final.mat', 'gy', 'gc');
end;

// On force la date trimestrielle pour que les graphiques soient beaux
dates(1Q1);

// 6. LANCEMENT DE L'ESTIMATION
estimation(
    datafile = 'dataset_final.mat', // On lit le fichier propre créé ci-dessus
    first_obs = 1,
    mh_replic = 2000,           
    mh_nblocks = 2,             
    mh_jscale = 0.3,            
    mode_compute = 6,           // Monte Carlo (Robuste)
    smoother,                   // Nécessaire pour la décomposition
    bayesian_irf
);

// 7. DECOMPOSITION DES CHOCS
shock_decomposition gy gc;