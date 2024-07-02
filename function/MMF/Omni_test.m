classdef Omni_test < PROBLEM
% <multi> <real> <multimodal>
% Multi-modal Multi-objective test Function

%--------------------------------------------------------------------------
% Copyright 2017-2018 Yiping Liu
% This is the code of MMF used in "Yiping Liu, Gary G. Yen, 
% and Dunwei Gong, A Multi-Modal Multi-Objective Evolutionary Algorithm 
% Using Two-Archive and Recombination Strategies, IEEE Transactions on 
% Evolutionary Computation, 2018, Early Access".
% Please contact {yiping0liu@gmail.com} if you have any problem.
%--------------------------------------------------------------------------
% MMF is proposed in " Caitong Yue, Boyang Qu, and Jing Liang, 
% A Multi-objective Particle Swarm Optimizer Using Ring Topology for 
% Solving Multimodal Multi-objective Problems, IEEE Transactions on 
% Evolutionary Computation, 2017, Early Access".
%--------------------------------------------------------------------------
% This code uses PlatEMO published in "Ye Tian, Ran Cheng, Xingyi Zhang, 
% and Yaochu Jin, PlatEMO: A MATLAB Platform for Evolutionary 
% Multi-Objective Optimization [Educational Forum], IEEE Computational 
% Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M = 2;
            obj.D = 3;
            obj.lower    = zeros(1,obj.D);
            obj.upper    = ones(1,obj.D)*6;
            obj.encoding = 'real';
            obj.Pname = 'Omni_test';
        end

        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            [N,~]  = size(PopDec);
            PopObj = NaN(N,obj.M);
            
            for j=1:N
                x=PopDec(j,:);
                f=zeros(2,1);
                n=length(x);
                for i=1:n
                    f(1)=f(1)+sin(pi*x(i));
                    f(2)=f(2)+cos(pi*x(i));
                end
                PopObj(j,:)=f;
            end
        end
    end
end
