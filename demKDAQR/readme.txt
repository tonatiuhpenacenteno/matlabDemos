This directory contains files that implement
the algorithms described in the NIPS 17 (2004) 
paper:
"Efficient Kernel Discriminant Analysis via QR 
decomposition" by Tao Xiong, et al.

The paper presents three different types of
algorithms:

1) Linear discriminant analysis via QR decomposition.
Termed in this demo as LdaQR. This algorithm was 
presented in a previous paper by Ye and Li and consists
of maximising Rayleigh's coefficient via the QR decomp.
of the matrix of centroids (over the data space)

2) Kernel discriminant analysis via QR decomposition.
Termed in this demo as KdaQR. This algorithm is just
the kernelisation of (1).

3) An approximation to algorithm (2) termed AKdaQR.
This is the most important algorithm of all as it  
presents the novelty of computing an approximation 
of the kernel matrix based on the computation of its 
centroids. This allows to have an algorithm with 
far less memory requirements.

Check the reference for further details. 

The demos available in this release are:
demLdaQR    
demKdaQR
dem2KdaQR
demAKdaQR
dem2AKdaQR

REQUIREMENTS:
This release requires the NDLUTIL toolbox written by Neil D.
Lawrence. More specifically, it uses the PDINV function to invert 
matrices. If you do not want to use this toolbox, then you will 
have to modify every line of code that calls PDINV by INV, which 
is the standard function available in Matlab.

################################################################

Tonatiuh Pena 
Readme file created: 24-Jan-05
Last modified: 20-Mar-06
