classdef IDMPM2T1_e < PROBLEM
% <multi/many> <real> <multimodal/preference>
% Imbalanced Distance Minimization Problems
% a --- 3 --- alpha

%--------------------------------------------------------------------------
% Copyright 2018-2019 Yiping Liu
% This is the code of benchmarks proposed in "Yiping Liu, Hisao Ishibuchi, 
% Gary G. Yen, Yusuke Nojima and Naoki Masuyama, Handling Imbalance Between 
% Convergence and Diversity in the Decision Space in Evolutionary Multi-
% Modal Multi-Objective Optimization, IEEE Transactions on Evolutionary 
% Computation, 2019, Early Access, DOI: 10.1109/TEVC.2019.2938557".
% Please contact {yiping0liu@gmail.com} if you have any problem.
%--------------------------------------------------------------------------
% This code uses PlatEMO published in "Ye Tian, Ran Cheng, Xingyi Zhang, 
% and Yaochu Jin, PlatEMO: A MATLAB Platform for Evolutionary 
% Multi-Objective Optimization [Educational Forum], IEEE Computational 
% Intelligence Magazine, 2017, 12(4): 73-87".
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
            obj.Pname = 'IDMPM2T1_e';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            NP = 2;
            for i=1:obj.M
                temp = abs(repmat(PopDec(:,1),1,NP)-repmat(obj.Points(i,:),N,1));
                temp(:,1) = temp(:,1)+1.*(abs(PopDec(:,2)+0.5)).^1;
                temp(:,2) = temp(:,2)+obj.a.*(abs(PopDec(:,2)-0.5)).^1;                
                PopObj(:,i) = min(temp,[],2);
            end
            
            % 加入local PF，右上角的global PF变成了local PF，问题包括一个global
            % PF（左下）和一个local PF（右上）
            index = PopDec(:,2)>0;
            PopObj(index,:) = PopObj(index,:)+0.01;
        end
        
        %% Generate Pareto optimal solutions (不变)
        function R = GetOptimum(obj,N)
            x(:,1) = linspace(-0.6,-0.4,N/2)';
            x(:,2) = linspace(0.4,0.6,N/2)';
            R = [x(:,1),repmat(-0.5,size(x(:,1)));x(:,2),repmat(0.5,size(x(:,1)))];
        end
        
       %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\IDMPM2T1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            Draw(L(1:size(L,1)/2,:),'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L(size(L,1)/2+1:end,:),'-','LineWidth',1,'Color',[.2 .2 1]);
        end
        
        %% Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp   = PopDec(:,1) <= 0;
            Draw(Population(temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(~temp).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            L  = [0:0.01:0.2;0.2-(0:0.01:0.2)]';
            Draw(L,'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L+0.01,'-','LineWidth',1,'Color',[.2 .2 1]);
        end
    end
end