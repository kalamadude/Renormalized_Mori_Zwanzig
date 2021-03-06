function coeffs = scaling_law(N,type)

% computed on [0,1] April 18
coeffs = zeros(4,1);
if strcmp(type,'c1B')
    coeffs(1) = exp(1.181884962799880)*N^-1.136707559532098;
end

if strcmp(type,'c3B13')
    coeffs(1) = exp(1.393341358946591)*N^-1.040824366121721;
    coeffs(3) = -exp(2.561714545817471)*N^-3.442935690461241;
end

if strcmp(type,'c1KdV')
    coeffs(1) = exp(0.705311893784875)*N^-1.201865905462570;
end

if strcmp(type,'c3KdV13')
    coeffs(1) = exp(0.613175492951107)*N^-1.015326020705753;
    coeffs(3) = -exp(0.192457601112031)*N^-3.344140327696319;
end

if strcmp(type,'c2B')
    coeffs(1) = exp(1.819785538424278)*N^-1.093945832760621;
    coeffs(2) = -exp(2.463587644947313)*N^-2.325237054919805;
end

if strcmp(type,'c3B')
    coeffs(1) = exp(1.541767557743583)*N^-0.981319248449383;
    coeffs(2) = -exp(1.922964860335419)*N^-1.982058125808136;
    coeffs(3) = exp(0.956206908843237)*N^-2.936870830980371;
end

if strcmp(type,'c4B')
    coeffs(1) = exp(1.905282695041228)*N^-1.066687205300492;
    coeffs(2) = -exp(2.796251624527494)*N^-2.162411635298580;
    coeffs(3) = exp(3.152391615308100)*N^-3.341672392051283;
    coeffs(4) = -exp(2.749000286715377)*N^-4.578886683293675;
end

if strcmp(type,'c2KdV')
    coeffs(1) = exp(1.355925631087403)*N^-1.167283767486007;
    coeffs(2) = -exp(1.625454761197602)*N^-2.495257671455809;
end

if strcmp(type,'c3KdV')
    coeffs(1) = exp(1.127866001886322)*N^-1.080944565654628;
    coeffs(2) = -exp(0.840901100313817)*N^-2.125957363772762;
    coeffs(3) = exp(-2.634244475274525)*N^-2.568963699218120;
end

if strcmp(type,'c4KdV')
    coeffs(1) = exp(1.238239895119442)*N^-1.082866452489714;
    coeffs(2) = -exp(1.577850807631149)*N^-2.233389525099544;
    coeffs(3) = exp(1.514640988759219)*N^-3.506872586205894;
    coeffs(4) = -exp(0.498971763306214)*N^-4.772363054617582;
end









% % computed on [0,1] April 18
% coeffs = zeros(4,1);
% if strcmp(type,'c1B')
%     coeffs(1) = exp(0.448226209847254)*N^-1.037478275973844;
% end
% 
% if strcmp(type,'c3B13')
%     coeffs(1) = exp(1.026897040121675)*N^-1.023355653066016;
%     coeffs(3) = -exp(1.985419032347491)*N^-3.467083921621617;
% end
% 
% if strcmp(type,'c1KdV')
%     coeffs(1) = exp(0.314440757201435)*N^-1.003403742262462;
% end
% 
% if strcmp(type,'c3KdV13')
%     coeffs(1) = exp(0.822852708436790)*N^-0.964493909734997;
%     coeffs(3) = -exp(1.414763060039584)*N^-3.305498921704734;
% end
% 
% if strcmp(type,'c2B')
%     coeffs(1) = exp(1.023957742100042)*N^-0.933225990220456;
%     coeffs(2) = -exp(1.062875699549107)*N^-2.042152074295630;
% end
% 
% if strcmp(type,'c3B')
%     coeffs(1) = exp(0.504298746401662)*N^-0.691900282678048;
%     coeffs(2) = -exp(0.250557422899735)*N^-1.510728560548495;
%     coeffs(3) = exp(-0.739068185587723)*N^-2.463585019710772;
% end
% 
% if strcmp(type,'c4B')
%     coeffs(1) = exp(0.768888898742228)*N^-0.748007690796749;
%     coeffs(2) = -exp(0.795526099544349)*N^-1.610077367980750;
%     coeffs(3) = exp(0.277303150179696)*N^-2.602969025438851;
%     coeffs(4) = -exp(-0.914449604693570)*N^-3.767212408891633;
% end
% 
% if strcmp(type,'c2KdV')
%     coeffs(1) = exp(0.885041695429977)*N^-0.896172437627729;
%     coeffs(2) = -exp(0.778092732102901)*N^-1.966261232903869;
% end
% 
% if strcmp(type,'c3KdV')
%     coeffs(1) = exp(0.411193844583827)*N^-0.667994978800210;
%     coeffs(2) = -exp(0.009038267140669)*N^-1.444582921628734;
%     coeffs(3) = exp(-1.208834238082156)*N^-2.328687246484139;
% end
% 
% if strcmp(type,'c4KdV')
%     coeffs(1) = exp(0.876113490946711)*N^-0.775286654220208;
%     coeffs(2) = -exp(0.937684101269703)*N^-1.636781379885954;
%     coeffs(3) = exp(0.475578450229902)*N^-2.622282068852214;
%     coeffs(4) = -exp(-0.453007350394811)*N^-3.811091383178751;
% end