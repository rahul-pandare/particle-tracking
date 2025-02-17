# Particle Tracking Algorithm  

For a detailed explanation of the theory and methodology, refer to my [Medium article](https://medium.com/@pandare.rahul/building-particle-tracking-algorithm-8e76f8ab4881).  

## Overview  
This repository contains a MATLAB-based particle tracking algorithm designed for analyzing two-dimensional snapshots of soft particles in a hopper. The algorithm leverages least-squares fitting via chi-squared minimization to accurately identify particle positions and sizes.  

## Methodology  
The tracking method employs a convolution-based chi-squared minimization approach to optimize particle detection. This technique ensures robust identification by minimizing the squared residuals between the observed and expected intensity distributions.  

## Repository Contents  
- **Input Data:** `particle_movie.mp4` (Sample video for tracking)  
- **Main Algorithm:** `particletracking_.m` (Primary script for particle tracking)  
- **Supporting Function Files:**  
  - `chiimg.m` – Computes the chi-squared value for image regions  
  - `clip.m` – Handles image clipping operations  
  - `ipf.m` – Image processing function for peak refinement  
  - `findpeaks.m` – Detects peaks in intensity profiles  

## Usage  
1. Place all function files in the working directory.  
2. Run `particletracking_.m` in MATLAB to execute the tracking algorithm.  

## Requirements
- MATLAB with Image Processing Toolbox (recommended)  
- Properly formatted input video containing distinguishable particles  

This implementation provides an efficient and accurate solution for tracking soft particles in experimental setups involving granular flows or dense suspensions.  
