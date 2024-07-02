classdef application < PROBLEM
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
            obj.D        = 2;
            obj.lower    = [0,0];
            obj.upper    = [2.5,1.5];
            obj.encoding = 'real';
            obj.Pname = 'application';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            A1=[0.1,1.4];    
            A2=[0.78,1.48];
            A3=[2.02,0.56];
            A4=[2.02-cos(pi*5/12)/2+sqrt(2)/4,0.56+sin(pi*5/12)/2+sqrt(2)/4];
            A5=[0.75,0.47];
            A=[A1;A2;A3;A4;A5]; 
            B1=[0.1,0.9];  
            B2=[0.78+sin(pi/9)/2,1.48-cos(pi/9)/2];
            B3=[2.02+sqrt(2)/4,0.56+sqrt(2)/4];
            B4=[0.34,0.095];
            B=[B1;B2;B3;B4]; 
            C1=[0.533,1.15];
            C2=[0.78+sin(pi/9)/2+cos(pi*5/18)/2,1.48-cos(pi/9)/2+sin(pi*5/18)/2];
            C3=[2.02-cos(pi*5/12)/2,0.56+sin(pi*5/12)/2]; 
            C4=[0.995,0.775];
            C5=[0.925,0.05];
            C6=[1.965,0.165];
            C7=[1.62,1.34];
            C8=[1.45,0.445];
            C9=[2.335,0.2];
            C10=[0.325,0.715];
            C=[C1;C2;C3;C4;C5;C6;C7;C8;C9;C10];
            N = size(PopDec,1);
            PopObj = NaN(N,obj.M);
            tempA = pdist2(PopDec(:,1:2),A);              
            PopObj(:,1) = min(tempA,[],2);      
            tempB = pdist2(PopDec(:,1:2),B);              
            PopObj(:,2) = min(tempB,[],2); 
            tempC = pdist2(PopDec(:,1:2),C);              
            PopObj(:,3) = min(tempC,[],2); 
        end
        %% Generate Pareto optimal solutions
        function R = GetOptimum(obj,N)
            temp = load('C:\Users\LZP\Desktop\lzp-evolution\PlatEMO-master3.4\PlatEMO-master\PlatEMO\TruePFPS\poly-PSPF\application.mat');
            R = temp;    
        end
        
        %% Display a population in the decision space
        function DrawDec(obj,Population)
            Draw(Population.decs,{'\it x\rm_1','\it x\rm_2','\it x\rm_3'});
            hold on
%             temp = load('D:\mycode_matlab\PlatEMO_3.5\PlatEMO\PFPS\IDMPM2T1_e_PFPS.mat', 'PSS');
            L = GetOptimum(obj,100);
            Draw(L.Pop_infeasible,'.','color',[0.5 0.5 0.5]);
            hold on
            A = L.A;
            B = L.B;
            C = L.C;
            sz=30;
            Draw(A,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0.4 1],'LineWidth',1.5);
            hold on 
            Draw(B,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 1 0],'LineWidth',1.5);
            hold on 
            Draw(C,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'LineWidth',1.5);
            hold on 
        end
    end
end