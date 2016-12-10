function [] = SaveAsPdf(filename, retning, fig)
orient(fig, retning)
print(filename, '-dpdf', '-bestfit');
end