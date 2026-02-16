% === SCRIPT MATLAB CORRIGÉ - VERSION FINALE (Indexation Locale) ===
fprintf('\n=== ANALYSE CONTREFACTUELLE SUR OMEGA ===\n');
fprintf('Omega \t Var(gy) \t Var(gc)\n');

% 1. Paramètres
omega_vals = [0.01, 0.25, 0.50, 0.75, 0.90];
idx_omega = strmatch('omega', M_.param_names, 'exact');
base_omega = M_.params(idx_omega);

% 2. Options de simulation
options_.order = 1;
options_.irf = 0;
options_.periods = 0;
options_.noprint = 1; 

% 3. Variables à simuler
var_list_ = {'gy', 'gc'};

% 4. Boucle et calcul
for i = 1:length(omega_vals)
    % A. On change le paramètre
    M_.params(idx_omega) = omega_vals(i);
    
    % B. On lance stoch_simul
    [info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_); 

    % C. CORRECTION DE L'INDEXATION
    % Dans oo_.var, gy est toujours en position 1 et gc en position 2 (car var_list_ l'impose)
    local_idx_gy = 1; 
    local_idx_gc = 2;
    
    % D. On récupère les variances (oo_.var est une matrice 2x2)
    var_gy = oo_.var(local_idx_gy, local_idx_gy);
    var_gc = oo_.var(local_idx_gc, local_idx_gc);
    
    % E. Affichage
    fprintf('%.2f \t %.5f \t %.5f\n', omega_vals(i), var_gy, var_gc);
end

% 5. On remet tout comme avant
M_.params(idx_omega) = base_omega;