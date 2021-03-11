# edge-detection-exp
# README

Brainstorming--all group members, 1 hour
Project Proposal--all group members, 1 hour

To run the code in experiment.m, you must have Psychtoolbox-3 installed.

Quick how-to-run:

1)Go to edge_detection_new script

2)Click "Run"

3)Watch how computer edge detection weakens as photo noise increases

4)Go to experiment script

5)Click "Run"

6)Enter your initials

7)Image will appear with 2 red horizontal lines and a small vertical line between them. Use right and left arrows to navigate alone red road and press enter at every edge between section you discern.

8)Once done with picture, press space bar to continue to next picture

9)Do this for 9 total photos

10)Go to analysis script

11)Add name of your run to array**

12)Click "Run"

13)See new graph with your data included and observe difference between human and computer edge detection



The scripts:

edgedetection: Implement Sobel edge detection on 3 images of varying degrees of complexity (silhouette of MATLAB logo, clipart sloth face, and Professor Serre's profile picture) with 3 different amounts of Gaussian blur (0, 0.02, and 0.04).
      Main script: for loop that reads images, runs functions to calculate values for calculating edge magnitude, and runs this fuction again after rotating the image 90 degress (rotation allows us to calculate both horizontal and vertical edges)
      For loop gif?: Generates collection of photos with large range of gaussian blur intensities and runs them through the edge detection calculations, saving the edge detection copies as well (in the 'blurred' folder). This is used by a function in the analysis script to generate an evolving visualization of computer edge detection accuracy as photo noise increases. (tldr: The gif).
      Convolve1D: Uses two kernels to calculate value for magnitude

experiment: user interface and data collection code

analysis: Takes in files generated by the human data and sobel operator and converts the black and white convolved image into a color image and generates an overlay image of the edge detected areas in red.
      Function: Creates 1x3 figure with original image increasing noise, computer detection of that, and an overlay. (tldr: Gif Generation)


Work breakdowns:

Saturday- first draft--pair coding for 2 hours, we switched off the driver every 40ish minutes.

Saturday night- edge detection research and first attempt at vertical edge detection--Megan 1.5 hours

Sunday- Created experiment script and adding the probe--Celin 1.5 hours

Sunday- Vertical edge detection dicussion and improvement--pair programming 1.5 hours, Megan drove the whole time, Catherine and Celine were passengers

Sunday(again)- made channel to save convolved photos (0.5 hours) and continued pair programming on edge detection for 1 hour--pair programming, Catherine drove, Celine and Megan were passengers

Monday- Office hours to improve edge detection performance (added thresholding)--Celine 1.5 hours 

Monday- Working on convolve1D function after office hours--Celine 1 hour

Tuesday- Starting graphing pseudocode and code, and worked on MATLAB and Github problems--Catherine 2 hours

Tuesday- edge detection and experiment improvemens--Celine 2 hours

Tuesday- Started graphs, changed edge detection, and Megan and Catherine tried to download PsychTool Box--Celine and Catherine drove, Megan passenger pair programming 2.5 hours

Wednesday (the wee hours)- First version of gif/evolving graph--Megan 2 hours

Wednesday- Celine continued working on the experient script--1.5 hours

Wednesday- analysis and graphs--pair programming, Catherine driving, Megan and Celine passengers 45 minutes

Wednesday- independent work on call (Catherine-1D computer analysis code, Megan--new design for gif program, Celine--human analysis code)--1.5 hours

Wednesday- Megan continued working on he gif data- 1 hour

Wednesday- gathering human data and fixing bugs--all together in common area (with masks), 3 hours
