function f = obj(x)

for c = 1:6
    r(c) = x(1);
end

for c = 7:10
    r(c) = x(2);
end

connects = [5,3; 3,1; 6,4; 4,2; 4,3; 2,1; 5,4; 6,3; 3,2; 4,1];
node = [18.28,9.14;18.28,0;9.14,9.14;9.14,0;0,9.14;0,0 ];

length = []; % m
for row = 1:10
    n1 = connects(row,1);
    n2 = connects(row,2);
    length = [length; get_length(node(n1,1), node(n1,2), node(n2,1), node(n2,2))];
end

f = 0; % kg
for i = 1:10
    f = f + pi*r(i)^2*length(i)*7860.0; % ±K«× 7860 kg/m^3
end

