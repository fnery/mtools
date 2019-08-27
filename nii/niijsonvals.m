function Out = niijsonvals(in, json_fields, silent)
% niijsonvals.m: get values from specific fields from .json sidecar(s)
%
% Syntax:
%    1) Out = niijsonvals(in, json_fields)
%    2) Out = niijsonvals(in, json_fields, silent)
%
% Description:
%    1) Out = niijsonvals(in, json_fields) takes .json files in 'in' and for
%       each returns the values from the fields given in 'json_fields'.
%       Organises results in a way that makes it easy to further work with the
%       fields/values and to identify where specific files are missing from
%       each .json
%    2) Out = niijsonvals(in, json_fields, silent) does the same as 1)
%       but allows to control whether the missing fields report strings are
%       printed to the command window
%
% Inputs:
%    1) in: can be one of the following:
%           a) directory where to look for .json files
%           b) char variable (path to .json file)
%           c) cell of chars (paths to .json files)
%    2) json_fields: names of fields to look for
%
% Outputs:
%    1) Out: struct containing
%       |--fields: input field names
%       |--files_fields: [nFiles x nFields] cell with field values
%       |--fields_miss_report: cell with missing fields report for each file
%
% Notes/Assumptions:
%    1) Only been tested with .json sidecar files generated with dcm2niix, so
%       may fail for more complex .json structures
%
% References:
%    []
%
% Required functions:
%    1) fdir.m
%    2) cellstrmatch.m
%    3) fileparts2.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20190730: original version
% fnery, 20190827: main input ('search_dir'->'in') now also accepts .json paths

SILENT_DEFAULT = true;
JSON_EXT = '.json'; % case insensitive (lower function called below)

if nargin < 2
    error('Error: this function needs at least 2 input arguments');
elseif nargin == 2
    silent = SILENT_DEFAULT;
elseif nargin > 3
    error('Error: this function accepts at most 3 input arguments');
end

% Retrieve .json path(s) from 'in'
if iscell(in)
    % Assume 'in' is a cell of .json paths
    json_paths = in;
elseif ischar(in)
    if isfolder(in)

        % Find files with JSON_EXT in DIR_TO_SEARCH (ignores subdirectories)
        List = fdir('in', in, 'ignoredirs', true, 'silent', true);
        exts = lower({List.ext});
        [~, idxs] = cellstrmatch(exts, JSON_EXT);
        List = List(idxs);

        if isempty(List)
            error('Error: no ''%s'' files were found in ''%s''', JSON_EXT, in)
        end

        json_paths = {List.fullpath};
    else
        % Assume 'in' is the path to a single .json file
        json_paths = {in};
    end
end

% Verify all extensions in 'json_paths' are indeed JSON_EXT
[~, ~, e] = fileparts2(json_paths);

allExtsAreJsons = strcmp(e{1}, JSON_EXT) && isallequal(e);
if ~allExtsAreJsons
    error('One or more files are not of .json format');
end

n_jsons = length(json_paths);

% Prep for looping over files
n_json_fields = length(json_fields);
files_fields = cell(n_jsons, n_json_fields);
fields_miss_report = {};
ct_miss = 0;

% Loop over each file, check which fields are missing, if any, store values
% of each field for each file
for i_json = 1:n_jsons

    % Read json
    c_json = json_paths{i_json};
    c_value = jsondecode(fileread(c_json));

    % Check if each field exists in current json
    for i_json_field = 1:n_json_fields
        c_json_field = json_fields{i_json_field};
        if isfield(c_value, c_json_field)

            % Store value of json field
            files_fields{i_json, i_json_field} = c_value.(c_json_field);
        end
    end

    % Get indices of missing fields, if any
    c_file_no_fields = json_fields(cellfun(@isempty, files_fields(i_json,:)));

    % If any field is missing, record this in a cell with a report for each
    % file where at least one field is missing
    if ~isempty(c_file_no_fields)
        ct_miss = ct_miss + 1;
        no_fields_string = sprintf('%s, ', string(c_file_no_fields));
        no_fields_string = no_fields_string(1:end-2);
        c_miss_str = sprintf('''%s'' missing fields: %s', ...
            c_json, no_fields_string);

        % Optionally print report of missing fields to cmd window
        if ~silent
            fprintf('%s\n', c_miss_str);
        end
        fields_miss_report{ct_miss} = c_miss_str;  %#ok<AGROW>
    end
end

% Save output struct
Out.fields = json_fields;
Out.files_fields = files_fields;
Out.fields_miss_report = fields_miss_report;

end