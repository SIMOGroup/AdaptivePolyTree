# Introduction
We provide here a Matlab-based polytree mesh refinement for limit analysis of cracked structures. 
The key idea is to develop a general refinement algorithm based on a so-called polytree mesh structure. 
The method is well suited for arbitrary polygonal elements and furthermore traditional triangular and quadrilateral ones, 
which are considered as special cases. Also, polytree meshes are conforming and can be regarded as a generalization of quadtree meshes. 
For the aim of this study, we restrict our main interest in plane-strain limit analysis to von Mises-type materials, yet its extension 
to a wide class of other solid mechanics problems and materials is completely possible. To avoid volumetric locking, we propose an approximate 
velocity field enriched with bubble functions using Wachspress coordinates on a primal-mesh and design carefully strain rates on a dual-mesh level. 
An adaptive mesh refinement process is guided by an L2-norm-based indicator of strain rates. Through numerical validations, we show that the present 
method reaches high accuracy with low computational cost. This allows us to perform large-scale limit analysis problems favorably. 

This Matlab codes can be extended to a wide range of engineering problems. 

1. Structure of AdaptivePolyTree package: 
- main.m: the main function for implementing AdaptivePolyTree to solve limit analyis problems.
- Other functions are given in subfolders.
2. How to run AdaptivePolyTree: 
- You need to install Mosek package, which may be free for academic purpose.  
- Run main.m and wait until the limit load factor reached.
- Get output

# Contributors
- Hung Nguyen-Xuan
- Son Nguyen-Hoang

# Funding Agency
The Alexander von Humboldt Foundation and Vietnam National Foundation for Science and Technology Development (NAFOSTED) under grant number 107.02-2014.24 

# References:
H. Nguyen-Xuan, S. Nguyen-Hoang, T. Rabczuk, K. Hackl, A polytree-based adaptive approach to limit analysis of cracked structures, 
Computer Methods in Applied Mechanics and Engineering, 313, 1006-1039, 2017.
