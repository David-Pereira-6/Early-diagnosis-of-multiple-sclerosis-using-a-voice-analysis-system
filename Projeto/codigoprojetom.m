%%
clear all
close all
clc

%% Adquirir a voz do paciente
gender = input('Qual é o seu gênero (M/F)?', 's'); % perguntar o género do paciente para um diagnóstico mais eficaz
fa = 8000; % definição da frequência de amostragem
N = 4*fa; % calcular o número de índices do sinal
n = 0:N-1; % gerar uma matriz linha com os vários indíces do sinal
t = n/fa; % gerar uma matriz linha para representação do sinal no tempo
if 1 % Trocaentre 0 e 1 para trocar entre o audio de uma pessoa sem esclorose multipla para o de uma pessoa diagnosticada com esclorose multipla
    info = audioinfo('audiovoz.wav'); % retirar a informação do sinal de audio gravado anteriormente
    x = audioread('audiovoz.wav'); % gerar uma matriz coluna com o sinal "audiovoz.wav" gerado anteriormente
else
    info = audioinfo('audioselmablairantes.wav');
    x = audioread('audioselmablairantes.wav');
end
h = firpm(100,[0 0.05 0.1 1],[1 1 0 0]); % Filtro passa-baixo para "limpar" o sinal
x_filtrado = filter(h,1,x);% calculo do sinal filtrado 
X = abs(fft(x_filtrado)); %passagem do sinal do domínio do tempo para o dominio das frequências
X = X(50:end/2); % o filtro utilizado "move" o sinal 100/2 indices para a frente, logo para retirar as frequencias corretas temos de recuar o sinal 50 casas
f = (0:length(X)-1/length(x)*fa); % calculo dos indíces para o dominio da frequencia
% Representação do sinal de voz, em cima no dominio do tempo e em baixo no
% dominio das frequências
figure(1)
subplot(2,1,1)
plot(t,x)
grid on
title('Gráfico da voz no domínio do tempo')
xlabel('tempo(s)')
ylabel('x-filtrado(t)')
subplot(2,1,2)
plot(f,X)
grid on
title('Gráfico da voz no domínio da frequência')
xlabel('k')
ylabel('X(k)')


%% Encontrar as frequências principais da voz do paciente

Xmenos = X; % criação de um sinal igual a X para não perder a informação
idx = [find(X>0.9999*max(X))]; % criação de uma lista de indices, tendo nesta fase apenas o indice do máximo do sinal
i = 1; % criação de uma variavel iteradora
picos = input('Após a observação da FFT, quantos picos observa?', 's'); % após a observação do sinal nas frequências, perguntar quantos picos são observados
picos = str2num(['uint8(',picos,')']);
while i < picos % após a observação do sinal nas frequências, observamos que o sinal apresentava 6 frequências principais
    Xmenos([idx(i)-120:idx(i)+120])=0; % Igualar os indices 35 menores e 35 maiores do máximo a 0 para eliminar picos nao desejáveis
    idx = [idx find(Xmenos>0.9999*max(Xmenos))]; % adicionar á lita de indices o novo máximo do sinal 
    i = i+1; % aumento de uma unidade no iterador
end
idx = sort(idx); % ordenar os indices por ordem crescente
ff = (idx(1)*fa)/N; % calculo da frequência fundamental real
% Representação do sinal no dominio das frequências, com os seus máximos
% realçados com bolas
figure(2)
plot(f,X,'k',idx,X(idx),'o')
grid on
title('Gráfico da voz no domínio da frequência com os picos destacados')
xlabel('k')
ylabel('X(k)')

fprintf('Valor da frequência fundamental da voz = %5.2f\n',ff)
fprintf('Número de picos observados no sinal de voz  = %5.2f\n',picos)
fprintf('Amplitude máxima do sinal de voz = %5.2f\n',max(X))

%% Tratamento do sinal

diagnostico = []; % criação de uma lista de diagnóstico

% verificar a redução da frequência fundamental da voz

if gender == 'M' % verificar o género do paciente
    if ff<95 % valor retirado do artigo mencionado no relatório
        diagnostico = [diagnostico, 1]; % para uma frequência menor que 85, o sintoma dá positivo e é adicionado um 1 a lista diagnostico
    else
        diagnostico = [diagnostico, 0]; % para uma frequência maior que 85, o sintoma dá negativo e é adicionado um 0 a lista diagnostico
    end
else
    if ff<187 % valor retirado do artigo mencionado no relatório
        diagnostico = [diagnostico, 1]; % para uma frequência menor que 172, o sintoma dá positivo e é adicionado um 1 a lista diagnostico
    else
        diagnostico = [diagnostico, 0]; % para uma frequência maior que 172, o sintoma dá negativo e é adicionado um 0 a lista diagnostico
    end
end

% verificar se a fala da pessoa é monotona

if picos<4
    diagnostico = [diagnostico,1]; % para um número de frequências menores que 4, o sintoma dá positivo e é adicionado um 1 a lista diagnostico
else
    diagnostico = [diagnostico,0]; % para um número de frequências maiores que 4, o sintoma dá negativo e é adicionado um 0 a lista diagnostico
end

% verificar se a amplitude da voz do paciente diminuiu

if gender == 'M' % verificar o género do paciente
    if max(X)<70 % valor retirado do artigo mencionado no relatório
        diagnostico = [diagnostico, 1]; % Para uma amplitude máxima menor do que 70, o sintoma dá positivo e é adicionado um 1 a lista diagnostico
    else
        diagnostico = [diagnostico, 0]; % Para uma amplitude máxima maior do que 70, o sintoma dá negativo e é adicionado um 0 a lista diagnostico
    end
else
    if max(X)<60 % valor retirado do artigo mencionado no relatório
        diagnostico = [diagnostico, 1]; % Para uma amplitude máxima menor do que 60, o sintoma dá positivo e é adicionado um 1 a lista diagnostico
    else
        diagnostico = [diagnostico, 0]; % Para uma amplitude máxima maior do que 60, o sintoma dá negativo e é adicionado um 0 a lista diagnostico
    end
end

%% diagonóstico final

if diagnostico == ones(length(diagnostico))
    disp('O paciente possui todos os sintomas de esclorose múltipla, considere visitar um médico')
else
    disp('O paciente não possui pelo menos um dos sintomas associados a esta doença, tenha um resto de bom dia ')
end