function [] = SaveAsPdf(filename, retning)
orient(gcf,retning)
print(filename, '-dpdf', '-bestfit');
end