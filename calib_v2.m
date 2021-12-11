function calib_v2(cameraIndex,imgName)
imgPath = 'D:\Study\Term3\EECE541\MediaFile\EECE541_LFCalib\release_1664_1232\release_1664_1232\';
intrinsicsPath = 'D:\Study\Term3\EECE541\MediaFile\CalibrationOutput1640\Calib_Results_stereo_0_';   % one for the camera 
savePath = 'D:\Study\Term3\EECE541\MediaFile\FinalOutput\';
cameraIndex=cameraIndex;
imgName = imgName;
referenceIndex = 1; 
cameraIndex = cameraIndex;
if cameraIndex < 10
    cameraIndexName = strcat('0',num2str(cameraIndex));
end
if cameraIndex >= 10
    cameraIndexName = num2str(cameraIndex);
end
myImgPath = strcat(imgPath,int2str(cameraIndex),'\',num2str(imgName),'.png');
referenceIntrinsicsPath = strcat(intrinsicsPath, num2str(referenceIndex));  

if cameraIndex > 13
    cameraIndex = cameraIndex-1;
end
cameraIntrinsicsPath = strcat(intrinsicsPath,num2str(cameraIndex));
matCamera = load(cameraIntrinsicsPath);
fprintf("Camera %s, image %d\n",cameraIndexName,imgName);
R = matCamera.R';
T = matCamera.T;
T = T/1000;
T(3) = 0;
P = horzcat(R,T);
Qc = horzcat(inv(R),-R\T);

z0 = 100; 
distortionParameters = matCamera.kc_left(1:2)';
Kc = matCamera.KK_left;

matReference = load(referenceIntrinsicsPath);
Kc0 = matReference.KK_left;
scaleFactor = 4;
perr = 1/scaleFactor;

if str2num(cameraIndexName) == 13
    Kc = matReference.KK_left;
    distortionParameters = matReference.kc_left(1:2)';
    R = eye(3);
    T = [0,0,0]';
    Qc = horzcat(inv(R),-R\T);
end
    
img_origin = imread(myImgPath); 
img_origin = imcrop(img_origin,[0,0,1640,1232]);
img_size = size(img_origin);
img_scale = imresize(img_origin,scaleFactor,'lanczos3');
img_scale_size = size(img_scale);
img_undist = zeros(img_size);
img_undist = uint8(img_undist);

for v = 1 : img_size(1)
    for u = 1 : img_size(2)
        origin_uv = [u;v];
        new_uv = calibrate(origin_uv, Kc, Kc0, distortionParameters,Qc,z0);
        if (new_uv(1) <= img_size(2)-1 && new_uv(1) >= 1 && new_uv(2) <= img_size(1)-1 && new_uv(2) >= 1)
            new_uv = new_uv * scaleFactor;
            new_uv = fix(new_uv);
            img_undist(v,u,:) = fix(img_scale(new_uv(2)-1,new_uv(1)-1,:)/9)...
            + fix(img_scale(new_uv(2)-1,new_uv(1),:)/9)...
            + fix(img_scale(new_uv(2)-1,new_uv(1)+1,:)/9)...
            + fix(img_scale(new_uv(2),new_uv(1)-1,:)/9)...
            + fix(img_scale(new_uv(2),new_uv(1),:)/9)...
            + fix(img_scale(new_uv(2),new_uv(1)+1,:)/9)...
            + fix(img_scale(new_uv(2)+1,new_uv(1)-1,:)/9)...
            + fix(img_scale(new_uv(2)+1,new_uv(1),:)/9)...
            + fix(img_scale(new_uv(2)+1,new_uv(1)+1,:)/9);
            
        end
    end
end

mySavePath = strcat(savePath,num2str(cameraIndexName),'_',num2str(imgName),'_calib','.png');
img_undist_cut=imcrop(img_undist,[65,134,1479,1026]);
img_undist_resize=imresize(img_undist_cut,[1232,1640],'lanczos3');
imwrite(img_undist_resize,mySavePath)
fprintf("save to %s\n",mySavePath);

function new_uv = calibrate(origin_uv, Kc,Kc0,distortionParameters, Qc, z0)
    pq = getPq(Qc, origin_uv, z0, Kc0);
    coefficents = Wc(distortionParameters, pq);
    new_uv = rectify(Kc,coefficents);
end

function new_uv = rectify(Kc,coefficents)
    output = Kc * [coefficents;1];
    new_uv = output(1:2);
end

function output = Wc(distortionParameters, pq)
    r = pq(1)^2 + pq(2)^2;
    output = (1 + distortionParameters(1) * r + distortionParameters(2) * r^2) * pq ;
end

function output = getPq(Qc, uv, z0, Kc0)
    Kc0_bias = Kc0;
    Kc0_bias(2,2) = Kc0_bias(1,1);
    Kc0_bias(1,2) = 0;
    temp1 = z0 * (Kc0_bias\[uv;1]);
    temp2 = Qc * [temp1;1];
    temp2 = temp2 / temp2(3); 
    output = temp2(1:2);
end
end
