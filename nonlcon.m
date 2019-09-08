function [c, ceq] = nonlcon(x)

[disp, stress] = get_tenbar_result(x);

stress_limit = 250*1e+6; % Pa
disp_limit = 0.02; % m

c_stress = abs(stress) - stress_limit;
c_disp = sqrt(disp(3)^2 + disp(4)^2) - disp_limit;

c = [c_stress; c_disp*1e+8]; 
ceq = [];
