function [disp, stress] = get_tenbar_result(x)

E = 200E+9; % Pa
node = [18.28,9.14;18.28,0;9.14,9.14;9.14,0;0,9.14;0,0 ];

% element 1~6 的半徑 
for c = 1:6
    r(c) = x(1);
end

% element 7~10 的半徑 
for c = 7:10
    r(c) = x(2);
end

% element 1~10 的面積(m^2)
for c = 1:10
    area(c) = pi*r(c)^2;
end

% element 1~10 的長度(m)
connects = [5,3; 3,1; 6,4; 4,2; 4,3; 2,1; 5,4; 6,3; 3,2; 4,1];

length = [];
for row = 1:10
    n1 = connects(row,1);
    n2 = connects(row,2);
    length = [length; get_length(node(n1,1), node(n1,2), node(n2,1), node(n2,2))];
end

% element 1~10 的SIN COS
sc = [];
for row = 1:10
    n1 = connects(row,1);
    n2 = connects(row,2);
    [s, c] = get_sincos(node(n1,1), node(n1,2), node(n2,1), node(n2,2), length(row));
    sc = [sc; s, c];
end

% 剛性矩陣
K = zeros(12,12);
nodes = [
    5,6,9,10;
    1,2,5,6;
    7,8,11,12;
    3,4,7,8;
    5,6,7,8;
    1,2,3,4;
    7,8,9,10;
    5,6,11,12;
    3,4,5,6;
    1,2,7,8];

for cn = 1:10
    k = [sc(cn,2).^2, sc(cn,2).*sc(cn,1), -sc(cn,2).^2, -sc(cn,1).*sc(cn,2);
         sc(cn,1).*sc(cn,2), sc(cn,1).^2, -sc(cn,2).*sc(cn,1), -sc(cn,1).^2;
        -sc(cn,2).^2, -sc(cn,2).*sc(cn,1), sc(cn,2).^2, sc(cn,2).*sc(cn,1);
        -sc(cn,2).*sc(cn,1), -sc(cn,1).^2, sc(cn,2).*sc(cn,1), sc(cn,1).^2];
    ke = zeros(12, 12);
    ke([nodes(cn,:)], [nodes(cn,:)]) = (E*area(cn)/length(cn)).*k;
    K = K + ke; % 剛性矩陣
end


K([9,10,11,12],:) = [];
K(:,[9,10,11,12]) = [];


f = [0;0;0;-1e7;0;0;0;-1e7] ; % 外力(N)
q = K\f; % 位移矩陣
q(9:12) = 0;
disp = q;



stress = [];
qq = [];
Q = [];
for cn = 1:10
    for count = nodes(cn,:)
        qq = [qq,q(count)];
    end
    Q = [ Q ; qq ];
    qq = [];
    stress = [stress ; (E/length(cn,:))*([-sc(cn,2), -sc(cn,1), sc(cn,2), sc(cn,1)]*Q(cn, :).')]; % 應力矩陣
end




