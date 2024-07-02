classdef IDMPM3T1_z < PROBLEM
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
            psize = [.1,.1,.3,.3];
            center = [-.5,-.5;.5,-.5;.5,.5;-.5,.5]; 
            obj.Points = NaN(obj.M,2,4);
            for i=1:4
                obj.Points(:,:,i) = pgon.Vertices.*psize(i)+center(i,:);
            end
            obj.Pname = 'IDMPM3T1_z';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            for i=1:obj.M
                temp = pdist2(PopDec(:,1:2),reshape(obj.Points(i,:,:),[2,4])');              
                temp(:,1) = temp(:,1)+1.*(abs(PopDec(:,3)+.6));
                temp(:,2) = temp(:,2)+2.*(abs(PopDec(:,3)+.2));
                temp(:,3) = temp(:,3)+1.*(abs(PopDec(:,3)-.2));
                temp(:,4) = temp(:,4)+2.*(abs(PopDec(:,3)-.6));
                PopObj(:,i) = min(temp,[],2);                
            end
        end
        %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\IDMP-e\IDMPM3T1_z.mat', 'PSS');
            R = temp.PSS;    
        end
        
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\IDMPM2T1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            temp = L(:,2)>0;
            Draw(L(temp,:),'.','Color',[.2 .2 1]);
            Draw(L(~temp,:),'.','Color',[1 .2 .2]);
        end
        
        %% Display a population in the objective space
        function DrawObj(obj,Population) 
%             Draw(Population.objs,'o','MarkerSize',4,'Marker','o','Markerfacecolor',[1 .2 .2],'Color',[1 .2 .2]);
            Draw(Population.objs);
            temp = load('C:\Users\wjy\Desktop\PlatEMO-master\PlatEMO-master\PlatEMO\TruePFPS\IDMP-e\IDMPM3T1_z.mat', 'PF');
            L = temp.PF;
            len = size(L,1);
            Draw(L(1:len/2,:),'.','Color',[1 .2 .2]);
            Draw(L(len/2+1:end,:),'.','Color',[.2 .2 1]);
        end
    end
end