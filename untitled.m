x = [1 2 3 4];
y = [10 5 15 20];

figure
plot(x, y)

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

xlim([-5 5])
ylim([-25 25])
xlabel('X-axis')
xlab = get(gca,'xlabel');
pos = get(xlab,'position');
set(xlab,'position',pos + [0 -20 0])
ylabel('Y-axis')
title('My Plot')

