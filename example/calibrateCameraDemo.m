% Auto-generated by cameraCalibrator app on 17-Feb-2019
%-------------------------------------------------------


% Define images to process
imageFileNames = {...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000002.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000003.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000004.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000005.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000006.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000007.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000008.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000009.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000010.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000011.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000012.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000013.png',...
    '/home/ethan/matlab/MultiModal_Data_Studio/TestData/calib-20180929/usb_cam/000014.png',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 77;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
