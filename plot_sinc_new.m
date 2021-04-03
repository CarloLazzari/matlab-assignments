%grafico della funzione sinc
T=1;
t=linspace(-5,5,101);
x=sinc(t./T);

plot(t,x);

%versione alternativa
x=zeros(1,length(t));
for n=1:length(t)
    if(t(n))==0
        x(n)=1;
    else
        x(n)=sin(pi*t(n)/T)/(pi*t(n)/T);
    end
end
figure;
plot(t,x,'r');

%altra alternativa
t2=t+eps*(t==0);
x=sin(pi*t2/T)./(pi*t2/T);
figure;
plot(t,x,'g');

