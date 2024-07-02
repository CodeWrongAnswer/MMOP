classdef IDMPM2T4_e < PROBLEM
% <multi/many> <real> <multimodal/preference>
% Imbalanced Distance Minimization Problems
% a --- 4 --- alpha

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
            obj.a       = obj.ParameterSet(4);
            obj.lower    = [-1,-1];
            obj.upper    = [1,1];
            obj.encoding = 'real';
            % Generate vertexes             
            psize = 0.10.*ones(1,2);
            center = [-0.50,0.50];
            obj.Points = [center - psize; center + psize]; 
            obj.Pname = 'IDMPM2T4_e';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            for i=1:obj.M
                temp = abs(repmat(PopDec(:,1),1,2)-repmat(obj.Points(i,:),N,1));
                temp(:,1) = temp(:,1)+100.*( +1 - cos(1.*2.*pi.*(PopDec(:,2)+0.5)) );
                temp(:,2) = temp(:,2)+100.*( +1 - cos(obj.a.*pi.*(PopDec(:,2)-0.5)) );
                PopObj(:,i) = min(temp,[],2);
            end
            
            % 加入local PF，见HREA_SM，左下角一个global PS，右上角2个等价local PS，右下角3个和左上角1个等价local PS（支配前面的local PS）
            index = PopDec(:,1) > 0;
            PopObj(index,:) = PopObj(index,:) + 0.01;
            
            index = PopDec(:,2) > 0.2;
            PopObj(index,:) = PopObj(index,:) + 0.01;
        end
         %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\IDMP-e\IDMPM2T4_e.mat', 'PSS');
            R = temp.PSS;
        end
        
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\IDMPM2T1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            len = size(L,1);
            Draw(L(1:len/7,:),'.','Color',[1 .2 .2]);
            Draw(L(len/7+1:len*5/7,:),'.','Color',[.2 1 .2]);
            Draw(L(len*5/7+1:end,:),'.','Color',[.2 .2 1]);
        end
        
        %% Display a population in the objective space
        function DrawObj(obj,Population)
            PopDec = Population.decs;
            temp1 = PopDec(:,1)<=0 & PopDec(:,2)<=0.2;
            temp3 = PopDec(:,1)>0 & PopDec(:,2)>0.2;
            temp2 = ~temp1 & ~temp3;
            
            Draw(Population(temp1).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[1 .5 .5],'Markeredgecolor',[1 .2 .2],{'\it f\rm_1','\it f\rm_2',[]});
            Draw(Population(temp2).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 1 .5],'Markeredgecolor',[.2 1 .2]);
            Draw(Population(temp3).objs,'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.5 .5 1],'Markeredgecolor',[.2 .2 1]);
            L  = [0:0.01:0.2;0.2-(0:0.01:0.2)]';
            Draw(L,'-','LineWidth',1,'Color',[1 .2 .2]);
            Draw(L+0.01,'-','LineWidth',1,'Color',[.2 1 .2]);
            Draw(L+0.02,'-','LineWidth',1,'Color',[.2 .2 1]);
        end
    end
end