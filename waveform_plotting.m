% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % Visual Adaptation Study (VisA) % % % % % % % % % % %
% % % % % % % % % % % Plotting ERP waveforms % % % % % % % % %
% % % % % % % % % % % % % % Dr Sussman's lab % % % % % % % % % % % % % % %
% % % % % % % % % % % Albert Einstein College of Medicine % % % % % % % % %
% % % % % % Last updated on 05/13/2016 by Huizhen Tang (Joann) % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear

%% Read data % % % % % % % % %
[fname,pathname] = uigetfile(...
    { '*.dat*','individual ERP waveforms';'*.*','All Files' }, ...
    'Select .dat file(s)', ...
    'Multiselect','on');

% Abort if the user hit 'Cancel'
if isequal(fname,0)||isequal(pathname,0),
    disp('Aborted.');
    return;
end

%% specify the number of variables 
prompt = {'Please indicate the total number of variables',...
    'Epoch starts at (e.g. -200 ms)',...
    'Epoch ends at (e.g. 3500 ms)' };
dlg_title = 'Variable number?';
num_lines = 1;
defAns = {'12','-100','400'};
answer = inputdlg(prompt,dlg_title,num_lines,defAns);%%% If the user clicks the Cancel button to close an input dialog box,
% % % Abort if the user clicks 'Cancel'.
if isempty(answer), disp('Aborted.');
    return;
end
[num status] = str2num(answer{1});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[stt status] = str2num(answer{2});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[endt status] = str2num(answer{3});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end

%% extract variable names
var = {};
for i = 1:num
    var{i} = fname{i}(end-6:end-4);
end

%% Group files based on variable names 
for nn = 1:num
    k = 0;
    for j = 1:length(fname)
       if fname{j}(end-6:end-4) == var{nn};
            k = k + 1;
              filename{k} = fname{j};
        else
        end
    end
  
%% Load and Reads data from low tone ERP
% if iscell(filename)== 1 %% detect whether multiple files are selected
for sj = 1:length(filename)
    ffile = fullfile(pathname,filename{sj});
  fprintf(1,'Processing %s\n',ffile);
  [fid,msg] = fopen(ffile, 'rt'); %%% get file indentifier. Here 'r' sets the permission, which is the type of access of the file, read, write, append, or update. attching a 't' specifies whether to open files in binary or text mode.
    if fid == -1,
        fprintf(1,'Error opening dat file "%s":', ffile);
        disp(msg);
        return;
    end  
    % identifier "fid" into a cell array.
    r_dat = textscan(fid, '%s'); %%% Before reading a file with textscan, you must open the file with the fopen function. fopen supplies the fid input required by textscan. When you are finished reading from the file, close the file by calling fclose(fid).
    fclose(fid);
    
    %% reshape vector format data to a matrix
    star = 200 + 1; % where the first numeric value starts
    data = r_dat{1}(star:end); %%% taking the data from begining to the end
    data(59233:59235) = [];
    
    for j=1:length(data), %The step is 3, means only reading the third column--which is the mean value of waveform
        val(j) = str2num(data{j});
    end
    tm = length(stt:(endt+1));
    el = length(data)/tm;
    wave(sj,:,:) = reshape(val,[tm,el]);
    
end
% save([pathname filename{1}(1:10) filename{1}(41:end-4)],'wave')
save([pathname filename{1}(1:10) filename{1}(18:end-4)],'wave')
end

%% Code ends here 
