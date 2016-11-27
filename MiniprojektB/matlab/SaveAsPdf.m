function [] = SaveAsPdf(filename, retning, fig)
orient(fig, retning)
print(graphics\filename, '-dpdf', '-bestfit');
end