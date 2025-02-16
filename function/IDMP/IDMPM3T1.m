classdef IDMPM3T1 < PROBLEM
% <multi/many> <real> <multimodal/preference>
% Imbalanced Distance Minimization Problems

%------------------------------- Reference --------------------------------
% Liu, Y., Ishibuchi, H., Yen, G.G., Nojima, Y. and Masuyama, N., 2020. 
% Handling imbalance between convergence and diversity in the decision 
% space in evolutionary multimodal multiobjective optimization. IEEE 
% Transactions on Evolutionary Computation, 24(3), pp.551-565.
%------------------------------- Copyright --------------------------------
% Copyright Yiping Liu
% Please contact {yiping0liu@gmail.com} if you have any problem.
%--------------------------------------------------------------------------

    properties(Access = private)
        Points; % Vertexes
    end
    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M        = 3; 
            obj.D        = 3;
            obj.lower    = [-1,-1,-1];
            obj.upper    = [1,1,1];
            obj.encoding = 'real';
            % Generate vertexes             
            pgon = nsidedpoly(obj.M);
            psize = [.1,.1,.1,.1];
            center = [-.5,-.5;.5,-.5;.5,.5;-.5,.5]; 
            obj.Points = NaN(obj.M,2,4);
            for i=1:4
                obj.Points(:,:,i) = pgon.Vertices.*psize(i)+center(i,:);
            end
            obj.Pname = 'IDMPM3T1';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            for i=1:obj.M
                temp = pdist2(PopDec(:,1:2),reshape(obj.Points(i,:,:),[2,4])');              
                temp(:,1) = temp(:,1)+1.*(abs(PopDec(:,3)+.6));
                temp(:,2) = temp(:,2)+2.*(abs(PopDec(:,3)+.2));
                temp(:,3) = temp(:,3)+3.*(abs(PopDec(:,3)-.2));
                temp(:,4) = temp(:,4)+4.*(abs(PopDec(:,3)-.6));
                PopObj(:,i) = min(temp,[],2);                
            end             
        end
         % Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp1   = PopDec(:,1)<=0;
            temp2   = PopDec(:,2)<=0;
            Draw(Population(temp1&temp2).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(temp1&~temp2).objs+0.05,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            Draw(Population(~temp1&temp2).objs+0.1,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 1 .5],'Markeredgecolor',[.2 1 .2]);
            Draw(Population(~temp1&~temp2).objs+0.15,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 1],'Markeredgecolor',[1 .2 1]);
        end
    end
end