
%grafico funzione esp
%ascissa frequenza,vettore frequenze
f=linspace(-5,5,101);
T=1;
S=T./(1+1i*2*pi*f*T);
ampiezza=abs(S);
plot(f,ampiezza);
