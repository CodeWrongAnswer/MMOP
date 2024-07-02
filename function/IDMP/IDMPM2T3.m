classdef IDMPM2T3 < PROBLEM
% <multi/many> <real> <multimodal/preference>
% Imbalanced Distance Minimization Problems
% a --- .4 --- alpha

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
        a;      % alpha
        Points; % Vertexes
    end
    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M        = 2; 
            obj.D        = 2;
            obj.a       = obj.ParameterSet(3);
            obj.lower    = [-1,-1];
            obj.upper    = [1,1];
            obj.encoding = 'real';
            % Generate vertexes             
            psize = 0.10.*ones(1,2);
            center = [-0.50,0.50];
            obj.Points = [center - psize; center + psize]; 
            obj.Pname = 'IDMPM2T3';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            for i=1:obj.M
                temp = abs(repmat(PopDec(:,1),1,2)-repmat(obj.Points(i,:),N,1));                             
                temp(:,1) = temp(:,1)+100.*abs(PopDec(:,2)+0.5).^2;
                temp(:,2) = temp(:,2)+100.*( PopDec(:,2)-0.5 + obj.a.*(PopDec(:,1)-0.5)).^2;               
                PopObj(:,i) = min(temp,[],2); 
            end  
        end
        % Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp   = PopDec(:,1)<=0;
            Draw(Population(temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(~temp).objs+0.1,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            L  = [0:0.01:0.2;0.2-(0:0.01:0.2)]';
            Draw(L,'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L+0.1,'-','LineWidth',1,'Color',[.2 .2 1]);
        end
    end
end