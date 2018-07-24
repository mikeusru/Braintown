function T = uaa_convert_table_column_to_cell(T, column_name)
if ~iscell(T.(column_name))
    T.(column_name) = num2cell(T.(column_name));
end