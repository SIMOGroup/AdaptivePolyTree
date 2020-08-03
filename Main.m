%==========================================================================
%      Matlab code of 2D crack problems using triangular,
%      quadrilateral and polygonal elements with PolyTree algorithm 
%==========================================================================
% Coded by: Hung Nguyen-Xuan   (HUTECH - Vietnam)
%           Son Nguyen-Hoang   (Seoul National University of
%                               Science and Technology - South Korea)
% Email: h.nguyenxuan@gmail.com
%        mrnguyenhoangson@gmail.com
%==========================================================================
clc;
clear all;
close all;

format long g
addpath Function
addpath Meshes_and_Boundaries
addpath Meshes_and_Boundaries/Mesh_Data
addpath Elements
addpath Elements/FEM
addpath Elements/ES_FEM
addpath Elements/Triangular_Quadrature
addpath Limit
addpath PostProcessing
addpath AdaptiveMeshes
addpath AdaptiveMeshes/Polytree
addpath AdaptiveMeshes/Dividing_Auto_Polygon
addpath AdaptiveMeshes/Bisection

%================= Choosing Problems ======================================
FEM.Example=7;
% Notched tensile specimen (a=1/2)
%       [1]: a=1/2;
%       [2]: a=1/3;
%       [3]: a=2/3;

%[4]: Thick clamped beam (B=1,2,5)
FEM.FactorInitial.ChooseLB=4; %(B=1:0.5:5)

%[5]: Rectangular block with two circle holes(phi=0)
%[6]: Rectangular block with two circle holes(phi=30)

%[7]: Ductile failure in porous metals

%================= Choosing Elements ======================================

FEM.OptionElement=[6];
% [1]:T3                  [2]:Q4                [3]:Polygon
% [4]:CubicBubble-T3      [5]:CubicBubble-Q4    [6]:CubicBubble-Polygon


%===================== Running ============================================
FEM.MaxIt=6;
FEM.LoadFactor=zeros(FEM.MaxIt,3,length(FEM.OptionElement));

for ielement=1:length(FEM.OptionElement)
    close all
    %------------------------
    FEM=ChoosingElements(FEM,FEM.OptionElement(ielement));
    %------------------------
    FEM=Material2D(FEM);
    %------------------------
    [FEM]=Making_Mesh(FEM);
    %------------------------
    for iter=1:FEM.MaxIt
        %----
        FEM=Central_Nodes_And_Connectivity(FEM);
        %----
        FEM=Informations_ESFEM(FEM);
        %----
        FEM=Making_Boundary_2D(FEM);
        %----
        FEM=ForceVector(FEM);
        %----
        [FEM]=StrainMatrix(FEM);
        %----
        [FEM]=Build_Matrices_OP(FEM);
        %----
        [FEM]=Mosek_Optimisation(FEM);
        fprintf('============================')
        Result_Only_See=[iter;FEM.LoadFactor]
        fprintf('============================\n')
        %----
        Plot_Displacement(FEM,1e-1,iter);
        %----
        [FEM]=LoadFactor_Comparison(FEM,ielement,iter);

        %----
        [FEM]=Estimating_Dissipation(iter,FEM);
        %----
        switch FEM.TypeElement.Name
            case {'T3','CubicBubble_T3'}
                FEM.AdaptiveMesh.Theta=0.5;
                % Dung bisection
                [FEM]=Adaptive_Mesh_T3_Bisection(iter,FEM);
                
                % Chia tam giac thanh 4 tam giac nho
                %[FEM]=Adaptive_Mesh_Q4_T3(iter,FEM);
            case {'Q4','CubicBubble_Q4'}
                FEM.AdaptiveMesh.Theta=0.9;
                [FEM]=Adaptive_Mesh_Q4_T3(iter,FEM);
            case {'Polygon','CubicBubble_Polygon'}
                if (FEM.Example==1 | FEM.Example==2 | FEM.Example==3)
                    if iter==1
                        FEM.AdaptiveMesh.Theta=0.95;
                    else
                        FEM.AdaptiveMesh.Theta=0.9;
                    end
                elseif FEM.Example==4
                    FEM.AdaptiveMesh.Theta=0.95;
                elseif FEM.Example==5 
                    FEM.AdaptiveMesh.Theta=0.9;
                elseif FEM.Example==6
                    FEM.AdaptiveMesh.Theta=0.85;
                elseif FEM.Example==7
                    FEM.AdaptiveMesh.Theta=0.5;
                else
                end
                [FEM]=Adaptive_Mesh_Poly(iter,FEM);  
        end
    end

end
%=================== PLot results =========================================
Post_Processing(FEM)





