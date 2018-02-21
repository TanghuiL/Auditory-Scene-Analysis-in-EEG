% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % Auditory streaming study (SDD) % % % % % % % % % % %
% % % % % % % % % % % Importing ERP mean value % % % % % % % % %
% % % % % % % % % % % % % % Dr Sussman's lab % % % % % % % % % % % % % % %
% % % % % % % % % % % Albert Einstein College of Medicine % % % % % % % % %
% % % % % % Last updated on 09/28/2016 by Huizhen Tang (Joann) % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear

%% Read data % % % % % % % % %
[fname,pathname] = uigetfile(...
    { '*.dat*','mean value of defined ERP';'*.*','All Files' }, ...
    'Select .dat file(s)', ...
    'Multiselect','on');
% Abort if the user hit 'Cancel'
if isequal(fname,0)||isequal(pathname,0),
    disp('Aborted.');
    return;
end
%% specify the number of conditions
prompt = {'Indicate the total number of conditions (e.g. hit and miss)',...
    'Indicate total number of electrodes (e.g. 13 or 32'};
dlg_title = 'parameters';
num_lines = 1;
defAns = {'2','32'};
answer = inputdlg(prompt,dlg_title,num_lines,defAns);%%% If the user clicks the Cancel button to close an input dialog box,
% % % Abort if the user clicks 'Cancel'.
if isempty(answer), disp('Aborted.');
    return;
end
[num status] = str2num(answer{1});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end
[nch status] = str2num(answer{2});
if ~status  %%%Handle empty value returned for unsuccessful conversion
    msgbox('Invalid Number','Error in Parameter settings','error');
end


%% get variable names
var = {};
for i = 1:num
    prompt = {'Type the condition base name'};
    dlg_title = 'Condition base name';
    num_lines = 1;
    defAns = {'_p3b_hit_diff.dat'};
    answer = inputdlg(prompt,dlg_title,num_lines,defAns);%%% If the user clicks the Cancel button to close an input dialog box,
    % Abort if the user clicks 'Cancel'.
    if isempty(answer), disp('Aborted.');
        return;
    end
    tem = answer{1};
    var{i} = tem;
end

%% Group files based on variable names 
for nn = 1:num
    k = 0;
    for j = 1:length(fname)
       if fname{j}(end-(length(var{nn})-1):end) == var{nn};
            k = k + 1;
              filename{k} = fname{j};
        else
        end
    end
%% Load and Reads data 
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
    r_dt = textscan(fid, '%s'); %%% Before reading a file with textscan, you must open the file with the fopen function. fopen supplies the fid input required by textscan. When you are finished reading from the file, close the file by calling fclose(fid).
    fclose(fid);  
    %% reshape vector format data to a matrix
    col = 3; %%% 3 is the number of colums 
    star = col + 2; 
    data = r_dt{1}(star:end); %%% taking the data from begining to the end
    n = 0;
    for j=3:3:length(data), %The step is 3, means only reading the third column--which is the mean value of waveform
        n = n + 1;
        mVal(sj,n) = str2num(data{j});
    end
end
save([pathname filename{1}(1:3) var{nn}(1:end-4)],'mVal')
end
%% Concatenate imported data % % % % % % % % %
[filename,pathname] = uigetfile(...
    { '*.mat*','mean value of defined ERP of all subjects';'*.*','All Files' }, ...
    'Select .mat file(s)', ...
    'Multiselect','on');
% Abort if the user hit 'Cancel'
if isequal(filename,0)||isequal(pathname,0),
    disp('Aborted.');
    return;
end
% This cell has the configuration of electrodues -- channel configuration 
if nch == 13
chls = {'Fz' 'Cz' 'Pz' 'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'LM' 'RM' 'HEOG' 'VEOG'};
elseif nch == 32
chls = {'FPz' 'Fz' 'Cz' 'Pz' 'Oz' 'FP1' 'FP2' 'F7' 'F8' 'F3' ...
     'F4' 'FC5' 'FC6' 'FC1' 'FC2' 'T7' 'T8' 'C3' 'C4' 'CP5' ...
    'CP6' 'CP1' 'CP2' 'P7' 'P8' 'P3' 'P4' 'O1' 'O2' 'LM' 'RM' 'EOG' };
else
end
%% write to excel spreadsheet
prompt = {'Save the value in excel as:'};
dlg_title = 'Output excel filename';
num_lines = 1;
defAns = {'p3b_meanVal'};
answer = inputdlg(prompt,dlg_title,num_lines,defAns);%If the user clicks the Cancel button to close an input dialog box,
% Abort if the user clicks 'Cancel'.
if isempty(answer), disp('Aborted.');
    return;
end
xlfname = answer{1};
for j = 1:length(filename)
    load([pathname filename{j}]);
    xlswrite(xlfname,chls,filename{j},'A1');
    xlswrite(xlfname,mVal,filename{j},'A2');
end
%% Code ends here 
