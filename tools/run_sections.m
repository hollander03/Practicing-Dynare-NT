% Run in an isolated working directory containing Code/sections/*.mod.
% Add the local Dynare matlab directory before invoking this script.
files=dir('s*.mod');
failed_models={};
for file_index=1:numel(files)
    model_name=files(file_index).name;
    fprintf('\nNT_RUN_BEGIN %s\n',model_name);
    try
        dynare(model_name,'noclearall','nograph');
        fprintf('NT_RUN_PASS %s\n',model_name);
    catch run_error
        fprintf('NT_RUN_FAIL %s: %s\n',model_name,run_error.message);
        failed_models{end+1}=model_name;
    end
end
assert(isempty(failed_models),'One or more section models failed; inspect NT_RUN_FAIL entries');
