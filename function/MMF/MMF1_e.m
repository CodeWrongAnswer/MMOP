classdef MMF1_e < PROBLEM
% <multi> <real> <multimodal>
% Multi-modal multi-objective test function

%------------------------------- Reference --------------------------------
% Caitong Yue, Boyang Qu, Kunjie Yu, Jing Liang, Xiaodong Li,
% A novel scalable test problem suite for multimodal multiobjective optimization,
% Swarm and Evolutionary Computation,
% Volume 48,
% 2019,
% Pages 62-71
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
            obj.lower    = [1 -20];
            obj.upper    = [3 20];
            obj.encoding = 'real';
            obj.Pname = 'MMF1_e';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec) 
            [N,~]  = size(PopDec);
            PopObj = NaN(N,obj.M);
            PopObj(:,1) = abs(PopDec(:,1)-2);
            index1 = PopDec(:,1)<2;
            PopObj(index1,2) = 1-sqrt(PopObj(index1,1))+2*(PopDec(index1,2)-sin(6*pi*PopObj(index1,1)+pi)).^2;
            index2 = PopDec(:,1)>=2;
            PopObj(index2,2) = 1-sqrt(PopObj(index2,1))+2*(PopDec(index2,2)-exp(PopDec(index2,1)).*sin(6*pi*PopObj(index2,1)+pi)).^2;
        end
        %% Generate Pareto optimal solutions
%         function R = GetOptimum(obj,N)
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\MMF1_e_PFPS.mat', 'PSS'); % 绝对路径
%             R = temp.PSS;
%         end
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\MMF1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            Draw(L(1:200,:),'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L(201:end,:),'-','LineWidth',1,'Color',[.2 .2 1]);
        end
        %% Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp   = PopDec(:,1)<2;
            Draw(Population(temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(~temp).objs+0.1,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            L  = [0:0.01:1;1-sqrt(0:0.01:1)]';
            Draw(L,'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L+0.1,'-','LineWidth',1,'Color',[.2 .2 1]);
        end
    end
end