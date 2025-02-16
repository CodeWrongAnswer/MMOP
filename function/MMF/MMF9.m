classdef MMF9 < PROBLEM
% <multi> <real> <multimodal>
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
            obj.lower    = [0.1,0.1];
            obj.upper    = [1.1,1.1];
            obj.encoding = 'real';
            obj.Pname = 'MMF9';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,X)
            PopDec = X;
            [N,~]  = size(PopDec);
            PopObj = NaN(N,obj.M);
            PopObj(:,1) = PopDec(:,1);             
            PopObj(:,2) = (2-(sin(2*pi*PopDec(:,2))).^6)./PopDec(:,1);
        end
        %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            x(:,1) = linspace(0.1,1.1,N/2)';
            x(:,2) = 1/4 * ones(1,N/2)';
            R = [x;x(:,1),x(:,2)+1/2];
            
%             scatter(R(:,1),R(:,2))
        end
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\MMF1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            Draw(L(1:50,:),'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L(51:end,:),'-','LineWidth',1,'Color',[.2 .2 1]);
        end
        %% Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp = PopDec(:,2) < 0.5;
            Draw(Population(temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(~temp).objs + 0.15,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            
            x(:,1) = (0.1:0.01:1.1);
            x(:,2) = 1/4 .* ones(size(x(:,1)));
            f = (2-(sin(2*pi.*x(:,2))).^6)./x(:,1);
            L  = [x(:,1),f];
            Draw(L,'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L+0.15,'-','LineWidth',1,'Color',[.2 .2 1]);
        end
        
    end
end