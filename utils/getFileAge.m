function age = getFileAge(filepath)
    file = dir(filepath);
    age = datetime('now') - file.date;
end