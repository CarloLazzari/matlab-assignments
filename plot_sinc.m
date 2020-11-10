%grafico della funzione sinc

T=1;
t=linspace(-5,5,101);
x=sinc(t./T);

plot(t,x)
