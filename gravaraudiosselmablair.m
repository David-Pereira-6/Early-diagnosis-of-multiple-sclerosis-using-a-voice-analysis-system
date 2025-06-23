%%
ready = input('Quando estiver pronta para falar aperte a tecla Enter', 's');
fa = 8000;
x = audiorecorder;
disp('Gravando áudio...');
recordblocking(x, 4);
disp('Gravação concluída!');
x = getaudiodata(x);
audiowrite("David\uni\2ºano-semestre 2\IAPS\Trabalhos práticos\Projeto\audioselmablairantes.wav", x, fa);

%%
ready = input('Quando estiver  pronto para falar aperte a tecla Enter', 's');
fa = 8000;
x = audiorecorder;
disp('Gravando áudio...');
recordblocking(x, 4);
disp('Gravação concluída!');
x = getaudiodata(x);
audiowrite("David\uni\2ºano-semestre 2\IAPS\Trabalhos práticos\Projeto\audiovoz.wav", x, fa);