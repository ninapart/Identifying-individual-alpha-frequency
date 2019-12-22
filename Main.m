close all
clear
clc

%% PART 1
% File paths and name patterns
%data_dir = strcat(pwd,'\data_dir\');
fullfile(getenv('USERPROFILE'), 'Downloads')
data_dir = strcat(fullfile(getenv('USERPROFILE'), 'Downloads'),'\data_dir\');
dir_pattern = strcat(data_dir,'**\*sub*.edf');
fname_pattern = ".*?0*(?<sub_num>\d+)[^\\]*(?<eyes>E[OC]).*\.edf";

% Get relevant files
dir_list = dir(dir_pattern);
files_names = strcat({dir_list.folder},'\',{dir_list.name});
files_match = regexpi(files_names, fname_pattern, 'names');

subjects = struct('num',{},'EO',{},'EC',{});
% Read files and organize data into the struct
for i = 1 :  length(files_names)
    if isempty(files_match{i})
        continue
    end
    
    % Check if the current file's subject is already in the list (since
    % each subject has 2 record files)
    sub_num = files_match{i}.sub_num;
    % If the subject is in list, add the file's data to his struct
    sub_index = find(arrayfun(@(s) isequal(sub_num, s.num), subjects));
    % If his not in the struct, we'll create a new record
    if isempty(sub_index)
        sub_index = length(subjects)+1;
    end
    
    subjects(sub_index).num = sub_num;
    [hdr, rec] = edfread(files_names{i});
    % Save the data
    subjects(sub_index).(files_match{i}.eyes).filename = files_names{i};
    subjects(sub_index).(files_match{i}.eyes).data = rec;
    subjects(sub_index).(files_match{i}.eyes).hdr = hdr;
end


%%% PART 2+3
Fs = 256; % Hz
freq_unit = "Frequency (Hz)";
ytext = "Magnitude";
channel = 19;
min_freq = 6;
max_freq = 14;

figure_title = "Subject %s";
figure_name = "IAF Analysis - " + figure_title;
plots_font_size = 12;
figure_position = [0.2, 0.2, 0.45, 0.6];

% pwelch consts
window = 5*Fs; % 5 times the sampling gap
noverlap = [];
window_step = 0.1;
f = min_freq:window_step:max_freq;

for sub = subjects
    if isempty(sub.EO) || isempty(sub.EC)
        fprintf("Subject %s is missing recording file!", sub.num);
        continue;
    end
    EO = sub.EO.data(channel,:);
    EC = sub.EC.data(channel,:);
    % Calculate the FFT
    [fq, PS_EO] = calcFftPS(EO, Fs);
    [fq, PS_EC] = calcFftPS(EC, Fs);
    % Reduce to the wanted frequency band
    band = min_freq<fq & fq<max_freq;
    fq = fq(band); PS_EC = PS_EC(band); PS_EO = PS_EO(band);
    
    figure('Name', sprintf(figure_name, sub.num), 'NumberTitle','off'); hold on;
    set(gcf, 'Units', 'Normalized', 'Position', figure_position);
    
    % Plot FFT power spectra
    subplot(2,2,1);
    plotPS(PS_EC, PS_EO, fq, "FFT");
    ylabel(ytext);
    set(gca,'fontsize', plots_font_size);

    % Plot difference spectrum
    subplot(2,2,3);
    plotDiff(PS_EC, PS_EO, fq, "FFT");
    xlabel(freq_unit);
    ylabel(ytext);
    set(gca,'fontsize', plots_font_size);
    
    % Calculate pwelch
    p_EO = pwelch(EO, window, noverlap, f, Fs);
    p_EC = pwelch(EC, window, noverlap, f, Fs);
    
    % Plot pwelch
    subplot(2,2,2);
    plotPS(p_EC, p_EO, f, "pwelch");
    set(gca,'fontsize', plots_font_size);
        
    % Plot difference spectrum
    subplot(2,2,4);
    plotDiff(p_EC, p_EO, f, "pwelch");
    xlabel(freq_unit);
    set(gca,'fontsize', plots_font_size);
    
    suptitle(sprintf(figure_title, sub.num));
end
















