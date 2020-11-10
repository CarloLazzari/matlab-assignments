function Onda_rettangolare(K,D)

if nargin<1
    fprintf('Uso: Onda_rettangolare(K,D), dove K è il numero di armoniche e D il duty-cicle\n');
    return;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRENO DI IMPULSI RETTANGOLARI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dutyCicle=D; % rapporto tra durata dell'impulso e periodo del segnale
ampiezza=1.0; % ampiezza del segnale

N=1000; % numero di campioni per periodo 
tempoMin=-1.0; % limite inferiore della scala dei tempi
tempoMax=+1.0; % limite superiore della scala dei tempi
tempo=linspace(tempoMin, tempoMax, N*(tempoMax-tempoMin)); % vettore tempo: contiene i valori di t da t_min a t_max 
f=linspace(tempoMin,tempoMax,N*(tempoMax-tempoMin));

%%%%%%%%%%%%%%%%%%
% segnale ideale %
%%%%%%%%%%%%%%%%%%
xIdeale=ampiezza*(abs(tempo-round(tempo))<=dutyCicle/2); %vettore che contiene i valori del segnale ideale, uno per ogni t
T0 = 1;
% xIdeale = ampiezza*abs(cos((2*pi/T0).*tempo));

%%%%%%%%%%%%%%%%%%%%%%%%%
% segnale approssimante %
%%%%%%%%%%%%%%%%%%%%%%%%%
componenteContinua=ampiezza*dutyCicle; 
k=(1:1:K); % vettore degli indici k

% coefficienti = (ampiezza/2)*dirac(f-1/T0)+(ampiezza/2)*dirac(f+1/T0);
coefficienti=ampiezza*sin(pi*dutyCicle*k)./(pi*k); % vettore dei coefficienti X_k
    
% equazione di sintesi per segnali reali
coseni=cos(2*pi*k'*tempo); % matrice dei cos(2.pi.k.t/To) per ogni valore di k e di t/To
xApprossimante=componenteContinua + 2*coefficienti*coseni; %vettore che contiene i valori del segnale approssimante, uno per ogni t
                                                           %vettore 1xN = vettore 1xK per matrice KxN


%%%%%%% grafico dei segnali
figure;
%set(gcf,'defaultaxesfontname','Courier New')

plot(tempo, xIdeale, 'Color', 'black', 'LineWidth', 1.5);
grid on; hold on;
plot(tempo, xApprossimante, 'Color', 'red', 'LineWidth', 2.5);

axis([tempoMin, tempoMax,-.5, 1.5]);
tmp=xlabel('Tempo normalizzato, t/T_0');
set(tmp,'FontSize',12);
legendaSegnaleApprossimante=sprintf('x_K(t) (K=%d)', K);
tmp=legend('x(t) (ideale)', legendaSegnaleApprossimante);
set(tmp,'FontSize',11);
titoloGrafico=sprintf('Sintesi del treno di impulsi rettangolari\ncon K=%d armoniche', K);
tmp=title(titoloGrafico);
set(tmp,'FontSize',14);


%%%%%%% grafico spettro di ampiezza (solo frequenze positive)
c=sqrt(coefficienti.^2); %vettore modulo dei coefficienti
c(K+1)=componenteContinua; k(K+1)=0; %si aggiunge la componente continua al vettore
figure;
plot(k,c,'o','LineWidth', 1.5);
grid on;
titoloGrafico=sprintf('Spettro di ampiezza con K=%d armoniche', K);
tmp=title(titoloGrafico);
set(tmp,'FontSize',14);
figure;
plot(tempo,xApprossimante-xIdeale,'o','LineWidth',0.5);
grid on;
titoloGrafico=sprintf('Valutazione errore massimo di ricostruzione');
tmp=title(titoloGrafico);
set(tmp,'Fontsize',14);

