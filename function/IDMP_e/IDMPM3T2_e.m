classdef IDMPM3T2_e < PROBLEM
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
            obj.Pname = 'IDMPM3T2_e';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            for i=1:obj.M
                temp = pdist2(PopDec(:,1:2),reshape(obj.Points(i,:,:),[2,4])');              
                temp(:,1) = temp(:,1)+100.*(abs(PopDec(:,3)+.6)).^2;
                temp(:,2) = temp(:,2)+100.*(abs(PopDec(:,3)+.2)).^1.8;
                temp(:,3) = temp(:,3)+100.*(abs(PopDec(:,3)-.2)).^1.6;
                temp(:,4) = temp(:,4)+100.*(abs(PopDec(:,3)-.6)).^1.4;
                PopObj(:,i) = min(temp,[],2);                
            end     
            
            % 加入local PF
            index1 = PopDec(:,2)>0;
            index2 = PopDec(:,1)>0;
            PopObj(index1&index2,:) = PopObj(index1&index2,:) + 0.03;
            PopObj(~index1&~index2,:) = PopObj(~index1&~index2,:) + 0.06;
        end
         %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\IDMP-e\IDMPM3T2_e.mat', 'PSS');
            R = temp.PSS;
        end
        
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\IDMPM2T1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            temp2 = L(:,1)>0 & L(:,2)>0;
            temp3 = L(:,1)<0 & L(:,2)<0;
            temp1 = ~temp2 & ~temp3;
            Draw(L(temp1,:),'.','Color',[1 .2 .2]);
            Draw(L(temp2,:),'.','Color',[.2 1 .2]);
            Draw(L(temp3,:),'.','Color',[.2 .2 1]);
        end
        
        %% Display a population in the objective space
        function DrawObj(obj,Population)
%             Draw(Population.objs,'o','MarkerSize',4,'Marker','o','Markerfacecolor',[1 .2 .2],'Color',[1 .2 .2]);
            Draw(Population.objs);
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\IDMP-e\IDMPM3T2_e.mat', 'PF');
            L = temp.PF;
            len = size(L,1);
            Draw(L(1:len/3,:),'.','Color',[1 .2 .2]);
            Draw(L(len/3+1:len*2/3,:),'.','Color',[.2 1 .2]);
            Draw(L(len*2/3+1:end,:),'.','Color',[.2 .2 1]);
        end
    end
end