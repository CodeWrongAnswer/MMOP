classdef MMF15_a < PROBLEM
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
            obj.M = 3;
            obj.D = 3;
            obj.lower    = [0 0 0];
            obj.upper    = [1 1 1];
            obj.encoding = 'real';
            obj.Pname = 'MMF15_a';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec) 
            [N,~]  = size(PopDec);
            PopObj = NaN(N,obj.M);
            M = obj.M;
            num_of_peak = 2;
            x = PopDec;
            t = (-0.5*sin(pi*x(:,end-1))+(x(:,end)));
            g = 2-exp(-2*log10(2).*((t+1/(2*num_of_peak)-0.1)/0.8).^2).*(sin(num_of_peak*pi.*(t+1/(2*num_of_peak)))).^2;
            y = repmat(1+g,1,M).*fliplr(cumprod([ones(size(g,1),1),cos(x(:,1:M-1)*pi/2)],2)).*[ones(size(g,1),1),sin(x(:,M-1:-1:1)*pi/2)];
            PopObj = y;
        end
        %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\MMF\MMF15_a.mat', 'PSS'); % 绝对路径
            R = temp.PSS;
        end
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\MMF\MMF15_a.mat', 'PF');
            L = GetOptimum(obj,100);
            Draw(L(1:size(L,1)/2,:),'.','Color',[1 .2 .2]);
            Draw(L(size(L,1)/2+1:end,:),'.','Color',[.2 .2 1]);
        end
        %% Display a population in the objective space
        function DrawObj(obj,Population)
%             PopDec = Population.decs;
%             temp   = PopDec(:,3)<0.5 | (PopDec(:,3)==0.5&PopDec(:,2)==0.5);
%             Draw(Population(temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
%             Draw(Population(~temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            Draw(Population.objs,{'\it f\rm_1','\it f\rm_2','\it f\rm_3'});
            
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\MMF\MMF15_a.mat', 'PF');
            L = temp.PF;
            Draw(L(1:625,:),'.','Color',[1 .2 .2]);
            Draw(L(626:end,:),'.','Color',[.2 .2 1]);
        end
    end
end