[x,y,z] = sphere(16);
X = [x(:)*.5 x(:)*.75 x(:) x(:)*2]; % These are the points.  In order to 
Y = [y(:)*.5 y(:)*.75 y(:) y(:)*2]; % color them, I need to put them into 
Z = [z(:)*.5 z(:)*.75 z(:) z(:)*2]; % columns

S = repmat([1 .75 .5 5]*10,numel(x),1); % This is the size of the circles
                                        % they stay the same size no matter
                                        % how the figure is zoomed
C = repmat([1 2 3 4],numel(x),1); % this is which color each point is
scatter3(X(:),Y(:),Z(:),S(:),C(:),'filled'), view(-60,60)