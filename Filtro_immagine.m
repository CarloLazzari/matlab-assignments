function Filtro_immagine(sigma_h)

if nargin<1 % il numero degli input e' insufficiente
    sprintf('Sintassi: Filtro_immagine(sigma_h)')
    return;
end

%%
% if (sigma_h>1)||(sigma_h<0)
%   sprintf('Errore, sigma h deve essere compreso tra 0 e 1 nel caso di un filtro laplaciano')
%   return;
% end
%%

% sigma_h parametro del filtro
% filtro gaussiano bidimensionale
% fspecial laplacian

% x=imread('rosa_orig','tiff'); % lettura dell'immagine
x=imread('scacchiera','png'); 
figure(1); imshow(x); % show image
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine originale');
set(tmp,'FontSize',12);

%% Filtraggio passa-basso
% h1=fspecial('gaussian',6*sigma_h,sigma_h); % risposta impulsiva del filtro passa-basso
% con un valore di sigma_h alto l'immagine filtrata con il LPF risulta molto sfocata, quella con HP risulta simile all'originale ma più scura.
h1=fspecial('average',sigma_h);
% returns a 3-by-3 filter approximating the shape of the two-dimensional Laplacian operator, alpha controls the shape of the Laplacian.

% h1=imgaussfilt(x',sigma_h);
y1=imfilter(x,h1); % filtraggio passa-basso
figure(2); imshow(y1);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine elaborata con il filtro passa-basso');
set(tmp,'FontSize',12);
%imwrite(y1,'Lena_lp.tif','tif');

%% Filtraggio passa-alto
z1=x-y1;% filtraggio passa-alto
%imwrite(z1,'Lena_hp_new.tif','tif');
figure(3); imshow(z1);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Immagine elaborata con il filtro passa-alto');
set(tmp,'FontSize',12);
%% Negativo e estrazione di contorno
quadratoBianco=255*ones(size(x),'uint8');
y2=quadratoBianco-2*z1;
figure(4); imshow(y2);
set(gcf,'defaultaxesfontname','Courier New')
tmp=title('Negativo');
set(tmp,'FontSize',12);
%imwrite(y2,'Lena_hp.tif','tif');
%%
%Filtro_immagine(10;
