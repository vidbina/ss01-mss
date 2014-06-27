% Representation of the loops I could detect

% V_p - I_x*(R_in_b+R_c) - I_d*R_d - I_2*R_2 = 0
% V_cc - I_1*R_1 + I_d*R_d - I_e*R_e = 0
% V_cc - I_1*R_1 + I_d*R_d + I_x*(R_in_b+R_c) - V_p
% V_cc  - I_1*R_1 - I_2*R_2 = 0
% -I_e*R_e + I_d*R_d + I_2*R_2 = 0
% V_p - I_x*(R_in_b+R_c) - I_e*R_e = 0

% Represented as a table the former equations would render the following:
%  V_p V_cc  V_1  V_2  V_d  V_x  V_e
circuits = [
     1    0    0   -1   -1   -1    0;
     0    1   -1    0    1    0   -1; 
    -1    1   -1    0    1    1    0;
     0    1   -1   -1    0    0    0;
     0    0    0    1    1    0   -1;
     1    0    0    0    0   -1   -1;
];
shitcircuits = [
     1   -1    0   -1   -1    0    0    0;
     0    1    0    0   -1    0   -1    0; 
    -1    1   -1    0    1    1    0    0;
     0    0    0    1    1    0   -1    0;
     1    0    0    0    0   -1   -1    0;
];
% Note that the final zero col is simply a remnant of the KVL

function retval = par(a, b)
  retval = (a*b)/(a+b);
endfunction

function retval = div(a, b)
  retval = a/(a+b);
endfunction

function retval = solveRC(R, C)
  retval = 1/(2*pi*R^2*C)
endfunction

Vcc = 3.3;
R_1 = 10e3; % 1e-6;
R_2 = 10e3;
R_d = 20e3;
R_e = 10e3;

R_vth_out_num = par(R_d+R_e, R_2);
R_vth_out = div(R_vth_out_num, R_1);
V_th = R_vth_out*Vcc*div(R_e, R_d)
i_th = div(par(R_2, R_d), R_1)*Vcc/R_d
R_th = V_th/i_th

