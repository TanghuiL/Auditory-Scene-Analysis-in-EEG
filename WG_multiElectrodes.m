% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % For ploting ERP waveforms % % % % % % % % % % %
% % % % % % % % % % % % % % VisA study 1 % % %  % % % % % %  % % % % %
% % % % % % % % % % % % Dr Sussman's lab % % % % % % % % % % % % % % %
% % % % % % % % % Albert Einstein College of Medicine % % % % % % % % %
% % % % Last updated on 10/25/2017 by Huizhen Tang (Joann) % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%% clear workspace
clear
%% specify the number of waveforms
prompt = {'Epoch starts at (e.g. -100 ms)','Epoch ends at (e.g. 800 ms)',...
    'Sampling rate (e.g. 500 Hz)','Electrodes','Condition?'};
dlg_title = 'Waveform properties';
num_lines = 1;
defAns = {'-100','500','500','1 2 3','SI'};
answer = inputdlg(prompt,dlg_title,num_lines,defAns);%%% If the user clicks the Cancel button to close an input dialog box,
% % % Abort if the user clicks 'Cancel'.
if isempty(answer), disp('Aborted.');
    return;
end
[stt status] = str2num(answer{1});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[endt status] = str2num(answer{2});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[ft status] = str2num(answer{3});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[chl status] = str2num(answer{4});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
cond = answer{5};
%% defining electrodes
if cond == 'DA'
    chls = {'FPz', 'Fz', 'Cz', 'Pz', 'Oz', 'FP1', 'FP2', 'F7', 'F8', 'PO9', ...
        'PO10', 'FC5', 'FC6', 'FC1', 'FC2', 'T7', 'T8', 'C3', 'C4', 'CP5', ...
        'CP6', 'CP1', 'CP2', 'P7', 'P8', 'P3', 'P4', 'O1', 'O2', 'LM', 'RM', 'EOG' };
elseif isequal(cond,'DI') || isequal(cond,'SI') || isequal(cond,'SA')
    chls = {'Fz', 'Cz', 'Pz', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'LM', ...
        'RM', 'HEOG','VEOG'};
else
end
%% Get ERP waveforms
% select waveform
[fname,pathname] = uigetfile(...
    { '*.dat*','Select ERP waveform';'*.dat','All dat Files' }, ...
    'Select the first waveform','Multiselect','off');
% Abort if the user hit 'Cancel'
if isequal(fname,0)||isequal(pathname,0),disp('Aborted.'); return; end
%% Load and Read waveform
ffile = fullfile(pathname,fname);
fprintf(1,'Processing %s\n',ffile);
[fid,msg] = fopen(ffile, 'rt'); %%% get file indentifier. Here 'r' sets the permission, which is the type of access of the file, read, write, append, or update. attching a 't' specifies whether to open files in binary or text mode.
if fid == -1,
    fprintf(1,'Error opening dat file "%s":', ffile);
    disp(msg);
    return;
end
% identifier "fid" into a cell array.
data = textscan(fid, '%s'); %%% Before reading a file with textscan, you must open the file with the fopen function. fopen supplies the fid input required by textscan. When you are finished reading from the file, close the file by calling fclose(fid).
fclose(fid);
%% reshape vector format data to a matrix
k = 0; wave_dt = []; data1 = data{1}(50:end);
for j = 1:length(data1)
    dt = str2num(data1{j});
    if ~isempty(dt), k=k+1; wave_dt(k) = dt; end
end
n_row = length(wave_dt)/length(chls); %length(chls) is the total number of channels.
for n = 1:n_row,
    D = wave_dt(((n-1)*length(chls)+1):n*length(chls));
    wave(n,:) = D;
end
%% waveform plotting
%% specify the scaling for y axis
prompt = {'Y asix scaling lower end','upper end','tick step'};
dlg_title = 'Waveform properties';
num_lines = 1;
defAns = {'-2','2','2'};
answer = inputdlg(prompt,dlg_title,num_lines,defAns);%%% If the user clicks the Cancel button to close an input dialog box,
% % % Abort if the user clicks 'Cancel'.
if isempty(answer), disp('Aborted.');
    return;
end
[y_lower status] = str2num(answer{1});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[y_upper status] = str2num(answer{2});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[y_stp status] = str2num(answer{3});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
%%%%%%%%%%
ts = stt:1000/ft:endt;
xl = length(ts); %x axis length
figure
rgb = [0 0 0;0 255 0;0 0 255;255 0 255;148 0 211]; rgb = rgb/255;
    plot(ts,wave(1:xl,chl(1)),'-','color',rgb(1,:),'LineWidth',6)
    hold on
    plot(ts,wave(1:xl,chl(2)),'-','color',rgb(2,:),'LineWidth',2)
    plot(ts,wave(1:xl,chl(3)),'-','color',rgb(3,:),'LineWidth',2)
    xlim([-100 500]); xticks([0 100 200 300 400 500])
    ylim([y_lower y_upper]); yticks(y_lower:y_stp:y_upper)
%     lgd = legend(chls{chl},'Location','NorthEastOutside');
%     lgd.Orientation = 'vertical'; lgd.Box = 'off'; lgd.FontSize = 24;
    grid on
    set(gca,'fontsize',24,'fontname','Times New Roman')
    ylabel('µV','fontsize',24,'fontname','Times New Roman');
    xlabel('Time (ms)','fontsize',24,'fontname','Times New Roman');
hold off
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8 4];
saveas(fig,(['MultiEl-diff-' fname '.png']));
saveas(fig,(['MultiEl-diff-' fname '.fig']));

