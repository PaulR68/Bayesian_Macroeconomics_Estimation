// =================================================================
// ESTIMATION SMM - PROJET FINAL (Question 5)
// =================================================================

// 1. Charger le modèle
@#include "Model.inc"

// 2. Déclarer les chocs pour l'initialisation
shocks;
    // On initialise le choc TFP avec une valeur standard
    var eta_A; stderr 0.01;
    // On éteint le choc Gouv pour le SMM (car pas demandé à cette étape)
    var eta_G; stderr 0; 
end;

// 3. Paramètres à estimer (Liste de la Question 5)
// 3. Paramètres à estimer (CORRIGÉ POUR ÉVITER L'ERREUR DE BORNE)
estimated_params;
    beta           , 0.998  , 0.90   , 0.99999;
    gamma_y        , 1.0036 , 1.00   , 1.05;
    stderr eta_A   , 0.01   , 0.0001 , 0.1;
    rho            , 0.90   , 0.01   , 0.9999;
    omega          , 0.30   , 0.01   , 0.90;
end;

// 4. Variables observées (Doivent être les en-têtes de ton CSV)
varobs gy gc gr;

// 5. Moments à matcher (Question 5)
matched_moments;
    gy;      // Moyenne Croissance PIB (E(gy))
    gc;      // Moyenne Croissance Conso (E(gc))
    gr;      // Moyenne Taux Intérêt (E(r))
    
    gy*gy;   // Variance Croissance PIB (Var(gy))
    gc*gc;   // Variance Croissance Conso (Var(gc))
end;

// 6. Lancer l'Estimation SMM avec le CSV
// IMPORTANT : data2.csv doit être fermé !
method_of_moments(
    mom_method = SMM,
    datafile   = 'data2.csv',         // Ton fichier CSV
    simulation_multiple = 5,          // Simulation 5x plus longue que les données
    order = 1,                        // Approximation linéaire
    seed = 1,                         // Pour reproduire les résultats
    weighting_matrix = ['DIAGONAL','OPTIMAL'], // Matrice de pondération
    mode_compute = 4,                 // Algorithme d'optimisation standard
    se_tolx = 1e-6,                   // Tolérance
    TeX,                              // Résultats en LaTeX
    mode_check                        // Vérification graphique
);