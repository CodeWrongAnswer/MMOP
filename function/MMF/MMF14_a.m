classdef MMF14_a < PROBLEM
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
            obj.M = 3;
            obj.D = 3;
            obj.lower    = [0,0,0];
            obj.upper    = [1,1,1];
            obj.encoding = 'real';
            obj.Pname = 'MMF14_a';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,X)
            PopDec = X;
            [N,~]  = size(PopDec);
            PopObj = NaN(N,obj.M);
            g = 2-(sin(2*pi*(PopDec(:,3)-0.5*sin(pi*PopDec(:,2))+0.25))).^2;
            PopObj(:,1) = cos(pi/2*PopDec(:,1)).*cos(pi/2*PopDec(:,2)).*(1+g);
            PopObj(:,2) = cos(pi/2*PopDec(:,1)).*sin(pi/2*PopDec(:,2)).*(1+g);
            PopObj(:,3) = sin(pi/2*PopDec(:,1)).*(1+g);
        end
        %% Generate Pareto optimal solutions
%         function R = GetOptimum(obj,N)
% % %             X  = UniformPoint(N/2,obj.M-1,'grid');
% % %             X(:,3) = 0.5 .* sin(pi * (X(:,2)));
% % %             
% % %             R = [X;[X(:,1),X(:,2),X(:,3)+0.5]];
% %             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\MMF14_a_PFPS.mat', 'PSS'); % 绝对路径
% %             R = temp.PSS;
%         end
       %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\MMF1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            Draw(L(1:625,:),'.','Color',[1 .2 .2]);
            Draw(L(626:end,:),'.','Color',[.2 .2 1]);
        end
        %% Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp   = PopDec(:,3)<0.5 | (PopDec(:,3)==0.5&PopDec(:,2)==0.5);
            Draw(Population(temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            ax = Draw(Population(~temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            
            a = linspace(0,pi/2,10)';
            X = 2.*sin(a)*cos(a');
            Y = 2.*sin(a)*sin(a');
            Z = 2.*cos(a)*ones(size(a'));
            mesh(ax,X,Y,Z,'EdgeColor',[.8 .8 .8],'FaceAlpha',0,'linewidth',1);  
            % two global PFs
        end
        
    end
end