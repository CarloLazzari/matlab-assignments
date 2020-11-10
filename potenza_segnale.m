
%% potenza segnale

T=1; %periodo
A=1; %ampiezza
fun = @(t)A*(cos((2*pi/T).*t));
fun_2 = @(t)fun(t).^2;
fprintf("Potenza del segnale coseno: ")
q = (1/T)*2*integral(fun_2,0,T/2);
fprintf('%d\n',q);

% La potenza di una sinusoide è (a^2)/2
