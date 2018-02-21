% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % Stream Dougle Deviant Study (SDD) % % % % % % % % % % %
% % % % % % % % % % % Importing MMN mean value % % % % % % % % %
% % % % % % % % % % % % % % Dr Sussman's lab % % % % % % % % % % % % % % %
% % % % % % % % % % % Albert Einstein College of Medicine % % % % % % % % %
% % % % % % Last updated on 04/20/2016 by Huizhen Tang (Joann) % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear

%% Read data % % % % % % % % %
[filename,pathname] = uigetfile(...
    { '*.dat*','mean value of defined ERP';'*.*','All Files' }, ...
    'Select .dat file(s)', ...
    'Multiselect','on');

% Abort if the user hit 'Cancel'
if isequal(filename,0)||isequal(pathname,0),
    disp('Aborted.');
    return;
end

%% Load and Reads data from low tone ERP 
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

sj

save([pathname filename{5}(1:3) filename{5}(end-8:end-4)],'mVal')
