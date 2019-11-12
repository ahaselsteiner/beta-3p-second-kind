pdTrue = Beta3pSecondKind(0.21, 14.21, 20.34);

x = [0:0.01:9];
f = pdTrue.pdf(x);

fig1 = figure('position', [100 100 450 280]);
plot(x, f);
 message = sprintf(['In Ferreira and Soares (1999), Fig. 1b \n' ...
     '(doi: 10.1016/S0029-8018(98)00022-5) \n' ...
     'the PDF peaks at ~2 m with density of ~0.4']);
text(2, 0.45, message, 'horizontalalignment', ...
    'left', 'fontsize', 8);
ylabel('Density (-)');
xlabel('Significant wave height (m)');
ylim([0 0.5]);
box off


n = 1000;
nOfSamples = 10;

alphaEstimated = nan(nOfSamples, 1);
kEstimated = nan(nOfSamples, 1);
nEstimated = nan(nOfSamples, 1);
for i = 1:nOfSamples
    sample = pdTrue.drawSample(n);
    pdEstimated(i) = Beta3pSecondKind();
    pdEstimated(i).fitDist(sample);
    alphaEstimated(i) = pdEstimated(i).Alpha;
    kEstimated(i) = pdEstimated(i).K;
    nEstimated(i) = pdEstimated(i).N;
end

fig2 = figure('position', [100 100 400, 130]);
subplot(1, 3, 1)
hold on
plot([0.5 1.5], [1 1], '-k')
boxplot(alphaEstimated, {'$$\hat{\alpha}$$'})
bp = gca;
bp.XAxis.TickLabelInterpreter = 'latex';
text(1.15, 1, [num2str(mean(alphaEstimated), '%1.3f') '+-' ...
    num2str(std(alphaEstimated), '%1.3f')], 'fontsize', 8, ...
    'verticalalignment', 'bottom'); 
box off

subplot(1, 3, 2)
hold on
plot([0.5 1.5], [1 1], '-k')
boxplot(kEstimated, {'$$\hat{k}$$'})
bp = gca;
bp.XAxis.TickLabelInterpreter = 'latex';
text(1.15, 1, [num2str(mean(kEstimated), '%1.3f') '+-' ...
    num2str(std(kEstimated), '%1.3f')], 'fontsize', 8, ...
    'verticalalignment', 'bottom');
box off

subplot(1, 3, 3)
hold on
plot([0.5 1.5], [2 2], '-k')
boxplot(nEstimated, {'$$\hat{n}$$'})
bp = gca;
bp.XAxis.TickLabelInterpreter = 'latex';
text(1.15, 2, [num2str(mean(nEstimated), '%1.3f') '+-' ...
    num2str(std(nEstimated), '%1.3f')], 'fontsize', 8, ...
    'verticalalignment', 'bottom'); 
box off
