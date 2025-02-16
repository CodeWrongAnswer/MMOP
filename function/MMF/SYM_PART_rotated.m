classdef SYM_PART_rotated < PROBLEM
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
            obj.D = 2;
            obj.lower    = [-20 -20];
            obj.upper    = [20 20];
            obj.encoding = 'real';
            obj.Pname = 'SYM_PART_rotated';
        end

        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            [N,~]  = size(PopDec);
            PopObj = NaN(N,obj.M);
            x=PopDec;

            a=1;
            b=10;
            c=8;
            w=pi/4;
            for i=1:N
           %% f2 
                xx1=cos(w)*x(i,1)-sin(w)*x(i,2);
                xx2=sin(w)*x(i,1)+cos(w)*x(i,2);
                x(i,1)=xx1;
                x(i,2)=xx2;
               %%
                temp_t1=sign(x(i,1))*ceil((abs(x(i,1))-(a+c/2))/(2*a+c));
                temp_t2=sign(x(i,2))*ceil((abs(x(i,2))-b/2)/b);
                t1=sign(temp_t1)*min(abs(temp_t1),1);
                t2=sign(temp_t2)*min(abs(temp_t2),1);
    
                x1=x(i,1)-t1*(c+2*a);
                x2=x(i,2)-t2*b;
                y=fun([x1,x2],a);
     
                PopObj(i,:) = y;
            end
        end
    end
end
%% 
function y=fun(x,a)
    y=zeros(2,1);
    y(1)=(x(1)+a)^2+x(2)^2;
    y(2)=(x(1)-a)^2+x(2)^2;
end