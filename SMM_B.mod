// =================================================================
// ESTIMATION SMM - VERSION STABLE (BETA FIXÉ)
// =================================================================

// 1. Charger le modèle
@#include "Model.inc"

// 2. Déclarer les chocs
shocks;
    var eta_A; stderr 0.01;
    var eta_G; stderr 0; 
end;

// 3. Paramètres à estimer
// CORRECTION : On a enlevé 'beta' de cette liste.
// Il gardera sa valeur fixée dans Model.inc (0.995) ou on peut le re-définir juste avant.
estimated_params;
    // PARAM       , INIT   , MIN    , MAX
    
    // gamma_y : On laisse l'algo chercher autour de 1.0036
    gamma_y        , 1.0036 , 1.00   , 1.05;
    
    // Choc TFP : On surveille rho pour qu'il ne tape pas 1.0
    stderr eta_A   , 0.01   , 0.0001 , 0.1;
    rho            , 0.90   , 0.01   , 0.99;  // Borne max stricte < 1
    
    // Part des consommateurs
    omega          , 0.30   , 0.01   , 0.90;
end;

// 4. Variables observées
varobs gy gc gr;

// 5. Moments à matcher
matched_moments;
    gy;      // E(gy)
    gc;      // E(gc)
    gr;      // E(r)
    gy*gy;   // Var(gy)
    gc*gc;   // Var(gc)
end;

// 6. Lancer l'Estimation SMM
// Astuce : Si 'beta' est trop bas pour tes données, le modèle aura du mal à matcher E(r).
// Tu peux essayer de changer beta manuellement ici si besoin :
// beta = 0.998; 

method_of_moments(
    mom_method = SMM,
    datafile   = 'data2.csv',
    simulation_multiple = 5,
    order = 1,
    seed = 1,
    weighting_matrix = ['DIAGONAL','OPTIMAL'],
    mode_compute = 4,   // Si ça plante encore, essaie mode_compute = 5
    se_tolx = 1e-6,
    TeX,
    mode_check
);