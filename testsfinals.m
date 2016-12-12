close all
%TEST 1 roll cnt pitch variable
openfig('err_roll_cnt_pitchstep1.fig');
hold on;
title('Roll Error: Roll cnt (=0) and pitch variable'); hold off;
openfig('err_pitchstep1_rolcnt.fig');
hold on;
title('Pitch Erro: Roll cnt (=0) and pitch variable '); hold off;
err_rolcnt_pitchvar=load('err_rolcnt_pitchstep1.mat');
err_rolcnt_pitchvar=abs(err_rolcnt_pitchvar.err_rol);
err_rolcnt_pitchvar=sum(err_rolcnt_pitchvar)/length(err_rolcnt_pitchvar)
err_pitchvar_rolcnt=load('err_pitchstep1_rolcnt.mat');
err_pitchvar_rolcnt=abs(err_pitchvar_rolcnt.err_pitch);
err_pitchvar_rolcnt=sum(err_pitchvar_rolcnt)/length(err_pitchvar_rolcnt)
%TEST 2 roll variable pitch cnt
openfig('err_pitchcnt_rollstep10.fig');
hold on;
title('Pitch Error: Roll variable and pitch cnt (=10) '); hold off;
openfig('err_rollstep10_pitchcnt10.fig');
hold on;
title('Roll Error: Roll variable and pitch cnt(=10 '); hold off;
rol_pithchcnt=load('roll_step10_10.mat');
rol_pitchcnt=abs(rol_pithchcnt.rol);
err_rolvar_pitchcnt=sum(rol_pitchcnt-(0:10:180))/length(rol_pitchcnt)
pitchcnt_rol=load('pitch_cnt10.mat');
pitchcnt_rol=pitchcnt_rol.pitch;
err_pithchcnt_rolvar=sum(pitchcnt_rol-10)/length(pitchcnt_rol)
% %TEST 3 roll and pitch variable randomly
% openfig('pitch7_err.fig');
% hold on;
% title('Error del Pitch amb roll variable i pitch variable '); hold off;
% openfig('rol7_err.fig');
% hold on;
% title('Error del Rol amb roll variable i pitch variable '); hold off;
% openfig('total_err7.fig');
% hold on;
% title('Mitja del Error de Roll i Pitch amb roll variable i pitch variable '); hold off;
% err_pitchvar_rolvar=load('err_pitch7_med.mat');
% err_pitchvar_rolvar= err_pitchvar_rolvar.err_pitch_med
% err_rolvar_pitchvar=load('err_rol7_med.mat');
% err_rolvar_pitchvar=err_rolvar_pitchvar.err_rol_med
% %TEST 4
% openfig('test8_err_pitch.fig');
% hold on;
% title('Error of pitch angle for each roll and pitch rotations'); hold off;
% openfig('test8_err_roll.fig');
% hold on;
% title('Error of Roll angle for each roll and pitch rotations'); hold off;
