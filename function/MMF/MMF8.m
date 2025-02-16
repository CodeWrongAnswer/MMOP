classdef MMF8 < PROBLEM
% <multi> <real> <multimodal/preference>
% Multi-modal multi-objective test function

%------------------------------- Reference --------------------------------
% C. Yue, B. Qu, and J. Liang, A multi-objective particle swarm optimizer
% using ring topology for solving multimodal multiobjective Problems, IEEE
% Transactions on Evolutionary Computation, 2018, 22(5): 805-817.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M = 2;
            obj.D = 2;
            obj.lower    = [-pi,0];
            obj.upper    = [pi,9];
            obj.encoding = 'real';
            obj.Pname = 'MMF8';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,X)
            temp = X(:,2) <= 4;
            y    = zeros(size(X,1),1);
            y(temp)  = X(temp,2) - sin(abs(X(temp,1))) - abs(X(temp,1));
            y(~temp) = X(~temp,2) - 4 - sin(abs(X(~temp,1))) - abs(X(~temp,1));
            PopObj(:,1) = sin(abs(X(:,1)));
            PopObj(:,2) = sqrt(1-PopObj(:,1).^2) + 2*y.^2;
        end
        %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            R(:,1) = linspace(-pi,pi,N/2)';
            R(:,2) = sin(abs(R(:,1))) + abs(R(:,1));
            R = [R;R(:,1),R(:,2)+4];
        end
        %% Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp1  = PopDec(:,1)<=0;
            temp2  = PopDec(:,2)<=4;
            Draw(Population(temp1&temp2).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(temp1&~temp2).objs+0.05,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            Draw(Population(~temp1&temp2).objs+0.1,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 1 .5],'Markeredgecolor',[.2 1 .2]);
            Draw(Population(~temp1&~temp2).objs+0.15,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 1],'Markeredgecolor',[1 .2 1]);
            L  = [0:0.01:1;sqrt(1-(0:0.01:1).^2)]';
            Draw(L,'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L+0.05,'-','LineWidth',1,'Color',[.2 .2 1]);
            Draw(L+0.1,'-','LineWidth',1,'Color',[.2 1 .2]);
            Draw(L+0.15,'-','LineWidth',1,'Color',[1 .2 1]);
        end
    end
end