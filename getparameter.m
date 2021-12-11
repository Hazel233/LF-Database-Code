addpath calibration amcctoolbox functions vgg D:\Softwares\MATLAB\amcctoolbox
addpath CornerFinder CornerFinder_origin D:\Softwares\MATLAB\amcctoolbox\amcctoolbox
addpath findcorners.m D:\Softwares\MATLAB\amcctoolbox\amcctoolbox\CornerFinder

% Where the images are (forward slashes only, and must include a trailing slash)
% input_dir = '/media/Datasets/101215/Calibrations/101215_151454_MultiCamera0/';
input_dir = 'D:\Study\Term3\EECE541\MediaFile\EECE541_LFCalib\calib_1640\calib_1640/';

% Where the data will be saved (forward slashes only, and must include a trailing slash). This folder should already exist
% output_dir = '/media/Datasets/101215/Calibrations/101215_151454_calibration/';
output_dir = 'D:\Study\Term3\EECE541\MediaFile\CalibrationOutput1640/';

% Image format: jpeg, bmp, tiff, png etc.
format_image = 'png';

% Length of each square of the checkerboard in the X direction (mm)
dX = 49.5;
% Length of each square of the checkerboard in the Y direction (mm)
dY = 49.5;

% number of *internal* square corners of the checkerboard in the X direction (do not include corners that are on the edge of the checkerboard)
nx_crnrs = 4;
% number of *internal* square corners of the checkerboard in the Y direction (do not include corners that are on the edge of the checkerboard)
ny_crnrs = 7;

% tolerance in pixels of reprojection of checkerboard corners. 2.0 is a reasonable number. By decreasing this number you are causing the calibrator to be more strict by throwing out more poorly estimated checkerboards, but potentially a more accurate calibration
proj_tol = 2.0;

% The index of the cameras to calibrate. In this example we are calibrating four cameras with sequential naming.
% camera_vec = [0 1 2 3]; % version 1.2 and before
% camera_vec = [0 1; 0 2; 0 3]'; % version 1.3a and later
camera_vec = [0 1; 0 2; 0 3; 0 4; 0 5; 0 6; 0 7; 0 8; 0 9; 0 10; 0 11; 0 12; 0 13; 0 14; 0 15; 0 16; 0 17; 0 18; 0 19; 0 20; 0 21; 0 22; 0 23; 0 24]';

% The index of the cameras to be rotated (1 for rotating 180 degrees). Rotcam must be the same dimensions as camera_vec
% rotcam = [0 0 0 0]; % version 1.2 and before
rotcam = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0]'; % version 1.3a and later. 

% indicate whether or not to use the fisheye calibration routine (not strictly required).
fisheye = false;

% indicate whether or not to use the third radial distortion term when doing a projective calibration (not strictly required)
k3_enable = false;

% the base naming convention for the calibration images (not strictly required), will default to the 'camX_image' convention if not used.
% cam_names = ['cam0_image', 'cam1_image', 'cam2_image', 'cam3_image']; % version 1.2 and before
% cam_names = ['cam0_image'; 'cam1_image'; 'cam2_image'; 'cam3_image']; % version 1.3a and later
cam_names = ['13_'; '01_'; '02_'; '03_'; '04_'; '05_'; '06_'; '07_'; '08_'; '09_'; '10_'; '11_'; '12_'; '14_'; '15_'; '16_'; '17_'; '18_'; '19_'; '20_'; '21_'; '22_'; '23_'; '24_'; '25_'];

% indicate whether or not to use the batch mode of the stereo calibrator (not strictly required)
batch = false;

% Perform the calibration
auto_multi_calibrator_efficient(camera_vec, input_dir, output_dir, format_image, dX, dY, nx_crnrs, ny_crnrs, proj_tol, rotcam, cam_names, fisheye, k3_enable, batch);