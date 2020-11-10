%% energia segnale

A=10; %ampiezza
T=1;
fun = @(t)A*(sinc(t./T));
fun_2 = @(t)fun(t).^2;
estremo_sinistro = -10000;
estremo_destro = 10000;
fprintf("Energia del segnale seno cardinale: ")
q = integral(fun_2,estremo_sinistro,estremo_destro);
fprintf('%d\n',q);
