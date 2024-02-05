

[xx_t,yy_t]         = meshgrid(-30:30,-30:30);
angle_view          = angle(xx_t+1i*yy_t);
distance_view       = sqrt(xx_t.^2+yy_t.^2);
% Set the dimensions of the ring
dimensionsRing                          = [0 30];
ring                = (distance_view>dimensionsRing(1)).*(distance_view<dimensionsRing(2));
angle_view(ring==0)=nan;
%angle_view(31,1:30)=nan;

surf(angle_view, 'EdgeColor','none')
 colormap jet
 %%
 set(gca,'ztick',linspace(-3.14,3.14,7))
set(gca,'zticklabel',num2str(round(180*linspace(-3.14,3.14,7)/pi)',3))
set(gca,'zlim',[-3.15 3.15])
 set(gca,'xticklabel',[])
 set(gca,'yticklabel',[])
axis tight
%view(0,90)
hCB = colorbar;


hCB.Ticks = linspace(-3.1,3.14,7);
hCB.TickLabels = num2str(round(180*linspace(-3.14,3.14,7)/pi)',3);