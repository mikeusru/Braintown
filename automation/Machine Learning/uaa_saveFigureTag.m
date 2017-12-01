function uaa_saveFigureTag(h,e)
%add filepath of clicked image to text file
global uaa
fPath = get(h,'Tag');
disp(get(h,'Tag'));
fileID = fopen(uaa.filePaths.imageIndexText,'a');
fPath = regexprep(fPath,'\\','\\\');
fprintf(fileID,['\r\n',fPath]);
fclose(fileID);
ax = get(h,'parent');
hold(ax,'on');
x = mean(get(ax,'Xlim'));
y = mean(get(ax,'Ylim'));
text(x,y,'Saved','Color','r','Parent',ax);
hold(ax,'off');