MarkovChain = dtmc(PI_asymp);
figure(3);
graphplot(MarkovChain, 'ColorEdges', true)
xFix = asymptotics(MarkovChain)
