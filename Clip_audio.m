function Clip_audio

%% Lettura campioni
filename='Sea.mp3';
fCampionamento = 44.1e3; % [Hz]: frequenza di campionamento = 44.1 kHz
tempoCampionamento = 1/fCampionamento; % tempo di campionamento
durataTransitorio=0.1; % [s]
durata = 4.0; % [s]
numeroCampioni = durata * fCampionamento; % numero totale di campioni
inizioCampioni = durataTransitorio*fCampionamento;
%x = wavread(filename, [inizioCampioni+1, inizioCampioni+1+numeroCampioni]); % canali sinistro + destro (segnale stereo)
%x = (x(:,1))'; % solo canale sinistro
[xstereo,~]=audioread(filename,[inizioCampioni+1,inizioCampioni+1+numeroCampioni]); %nuova versione da R2016
x = (xstereo(:,1))'; % solo canale sinistro
tempo=0:tempoCampionamento:durata;


%% Filtro passa-basso 
B=3000.; % [Hz]
T=20/B; % [s]
tempoFiltro=0:tempoCampionamento :T;
h=2*B*sinc(2*B*(tempoFiltro-T/2)).*rectpuls((tempoFiltro-T/2)/T);

%% Filtraggio
y=conv(x,h)*tempoCampionamento; % uscita filtrata
y=y(length(h):length(y));

tempoY=tempo(1:length(y))+T/2;

% f0=440; % [Hz]
% amp = 0.15;
% sovrascriviamo il vettore
% y = 3*amp*cos(2*pi*f0*tempoY); % vettoriale
% coefficienti di distorsione D2,D3,D5?

figure;
set(gcf,'defaultaxesfontname','Courier New')
plot(tempo-durataTransitorio, x, 'Color', 'cyan', 'LineWidth', 1.5);
hold on;
plot(tempoY-durataTransitorio, y, 'Color', 'black', 'LineWidth', 1.5);
grid on;
tmp=xlabel('Tempo (s)');
set(tmp,'FontSize',12);
tmp=ylabel('Segnali temporali');
set(tmp,'FontSize',12);
legend('x(t)', 'y(t)');
set(tmp,'FontSize',10);
axis([0 0.4 -0.8001 0.8001]);


%% Blocco nonlineare
yM=0.10; % ampiezza della saturazione, se = ad amp non cè distorsione
% yM=0.1;
z=y; % copia non distorta del segnale di ingresso
% z=y.*sign(y); %provo con un altro tipo di modello di NL
% z=yM*(1-exp(((-abs(y))./yM))).*sign(y); 
z(z>=yM)=yM; % clipping dei valori maggiori di yM
z(z<=-yM)=-yM; % clipping dei valori minori di -yM


figure;
set(gcf,'defaultaxesfontname','Courier New')
plot(tempoY-durataTransitorio, y, 'Color', 'cyan', 'LineWidth', 1.5);
hold on;
plot(tempoY-durataTransitorio, z, 'Color', 'black', 'LineWidth', 1.5);
grid on;
tmp=xlabel('Tempo (s)');
set(tmp,'FontSize',12);
tmp=ylabel('Segnali temporali');
set(tmp,'FontSize',12);
temp=legend('y(t)', 'z(t)');
set(tmp,'FontSize',10);
axis([0 0.4 -0.8001 0.8001]);



%% Calcolo della trasformata di Fourier dell'ingresso
lunghezzaFft=2^nextpow2(length(y));
Y=fft(y,lunghezzaFft)*tempoCampionamento;
Y=[Y(lunghezzaFft/2+1:lunghezzaFft) Y(1:lunghezzaFft/2)];
frequenza=fCampionamento*linspace(-0.5,0.5,lunghezzaFft);
frequenza=frequenza-frequenza(lunghezzaFft/2+1);

%% Calcolo della trasformata di Fourier dell'uscita
lunghezzaFft=2^nextpow2(length(z));
Z=fft(z,lunghezzaFft)*tempoCampionamento;
Z=[Z(lunghezzaFft/2+1:lunghezzaFft) Z(1:lunghezzaFft/2)];
frequenza=fCampionamento*linspace(-0.5,0.5,lunghezzaFft);
frequenza=frequenza-frequenza(lunghezzaFft/2+1);

figure;
set(gcf,'defaultaxesfontname','Courier New')
plot(frequenza/1e3,20*log10(abs(Y)./max(abs(Y))), 'Color', 'cyan', 'LineWidth', 1.5);
hold on;
plot(frequenza/1e3,20*log10(abs(Z)./max(abs(Y))), 'Color', 'black', 'LineWidth', 1.5);
plot(frequenza/1e3,20*log10(abs(Y)./max(abs(Y))), 'Color', 'cyan', 'LineWidth', 0.5);
grid on;
tmp=xlabel('Frequenza (kHz)');
set(tmp,'FontSize',12);
tmp=ylabel('Spettro di ampiezza (dB)');
set(tmp,'FontSize',12);
temp=legend('|Y(f)|', '|Z(f)|');
set(tmp,'FontSize',10);
axis([0 6 -100 20]);

%wavwrite(y, fCampionamento, 'Music_filtro.wav');
%wavwrite(z, fCampionamento, 'Music_dist.wav');
audiowrite('Output_filtro_clip.wav',[y.',y.'],fCampionamento);
audiowrite('Output_dist_clip.wav',[z.',z.'],fCampionamento);
