{$APPTYPE CONSOLE}
{$POINTERMATH ON}
// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_CalcOpticalFlowPyrLK;

{$R *.res}

uses
  System.SysUtils,
  uLibName in '..\..\..\include\uLibName.pas',
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  core_c in '..\..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
  legacy in '..\..\..\include\legacy\legacy.pas',
  calib3d in '..\..\..\include\calib3d\calib3d.pas',
  imgproc in '..\..\..\include\imgproc\imgproc.pas',
  haar in '..\..\..\include\objdetect\haar.pas',
  objdetect in '..\..\..\include\objdetect\objdetect.pas',
  tracking in '..\..\..\include\video\tracking.pas',
  Core in '..\..\..\include\�ore\core.pas';

const
  MAX_COUNT = 500;

Var
  image: pIplImage = nil;
  grey: pIplImage = nil;
  prev_grey: pIplImage = nil;
  pyramid: pIplImage = nil;
  prev_pyramid: pIplImage = nil;
  swap_temp: pIplImage;
  win_size: longint = 10;
  corners: pCvPoint2D32f;
  prev_features: pCvPoint2D32f;
  swap_points: pCvPoint2D32f;
  status: array [0 .. MAX_COUNT] of TCVChar;
  count: longint = 0;
  need_to_init: longint = 0;
  night_mode: longint = 0;
  flags: longint = 0;
  add_remove_pt: longint = 0;
  pt: TCvPoint;
  k: longint;
  { ----------------------- }
  capture: PCvCapture;
  frame: pIplImage;

  c: Integer;

procedure main_cycle();
var
  cs: TCvSize;
  eig, temp: pIplImage;
  quality, min_distance, dx, dy: double;
  i: Integer;
begin
  frame := cvQueryFrame(capture);
  if not(assigned(frame)) then
    exit;

  if not(assigned(image)) then
  begin
    // * allocate all the buffers
    cs.width := frame.width;
    cs.height := frame.height;
    image := cvCreateImage(cs, 8, 3);
    image.Origin := frame.Origin;
    grey := cvCreateImage(cs, 8, 1);
    prev_grey := cvCreateImage(cs, 8, 1);
    pyramid := cvCreateImage(cs, 8, 1);
    prev_pyramid := cvCreateImage(cs, 8, 1);
    flags := 0;
  end;

  cvCopy(frame, image);
  cvCvtColor(image, grey, CV_BGR2GRAY);

  if (night_mode = 1) then
    cvZero(image);

  if (need_to_init = 1) then
  begin
    // * automatic initialization
    eig := cvCreateImage(cvGetSize(grey), 32, 1);
    temp := cvCreateImage(cvGetSize(grey), 32, 1);
    quality := 0.101;
    min_distance := 10.0;

    count := MAX_COUNT;
    cvGoodFeaturesToTrack(grey, eig, temp, corners, @count, quality, min_distance, nil, 3, 0, 0.04);
    cvFindCornerSubPix(grey, corners, count, cvsize(win_size, win_size), cvsize(-1, -1),
      cvTermCriteria(CV_TERMCRIT_ITER or CV_TERMCRIT_EPS, 20, 0.03));
    cvReleaseImage(eig);
    cvReleaseImage(temp);

    add_remove_pt := 0;
  end
  else if (count > 0) then
  begin
    cvCalcOpticalFlowPyrLK(prev_grey, grey, prev_pyramid, pyramid, prev_features, corners, count,
      cvsize(win_size, win_size), 3, @status, nil, cvTermCriteria(CV_TERMCRIT_ITER or CV_TERMCRIT_EPS, 20,
      0.03), flags);
    flags := flags or CV_LKFLOW_PYR_A_READY;

    k := 0;
    for i := 0 to count - 1 do
    begin
      if (add_remove_pt = 1) then
      begin
        dx := pt.x - corners[i].x;
        dy := pt.y - corners[i].y;

        if (dx * dx + dy * dy <= 25) then
        begin
          add_remove_pt := 0;
          continue;
        end;
      end;

      if (status[i] = #0) then
        continue;

      corners[k] := corners[i];
      inc(k);
      cvCircle(image, cvPointFrom32f(corners[i]), 3, CV_RGB(0, 255, 0), -1, 8, 0);
    end;
    count := k;
  end;

  if ((add_remove_pt = 1) and (count < MAX_COUNT)) then
  begin
    corners[count] := cvPointTo32f(pt);
    inc(count);
    // newpoint -> points[1] + count - 1
    // newpoint := corners[count - 1];
    cvFindCornerSubPix(grey, @corners[count - 1], 1, cvsize(win_size, win_size), cvsize(-1, -1),
      cvTermCriteria(CV_TERMCRIT_ITER or CV_TERMCRIT_EPS, 20, 0.030));
    add_remove_pt := 0;
  end;

  CV_SWAP(prev_grey, grey, swap_temp);
  CV_SWAP(prev_pyramid, pyramid, swap_temp);
  CV_SWAP(prev_features, corners, swap_points);

  need_to_init := 0;
  { visualize the camera image in the window }
  cvShowImage('LkDemo', image);
end;

// ���������� ������� �� �����
procedure myMouseCallback(event: Integer; x: Integer; y: Integer; flags: Integer; param: pointer); cdecl;
begin
  if assigned(image) then
    case event of
      CV_EVENT_MOUSEMOVE:
        ;
      CV_EVENT_LBUTTONDOWN:
        begin
          pt := cvPoint(x, y);
          add_remove_pt := 1;
        end;
      CV_EVENT_LBUTTONUP:
        ;
    end;
end;

begin
  try
    capture := cvCreateCameraCapture(CV_CAP_ANY);
    Assert(assigned(capture));
    cvNamedWindow('LkDemo', CV_WINDOW_AUTOSIZE);
    cvSetMouseCallback('LkDemo', myMouseCallback);

    corners := AllocMem(SizeOf(TCvPoint2D32f) * MAX_COUNT);
    prev_features := AllocMem(SizeOf(TCvPoint2D32f) * MAX_COUNT);

    while true do
    begin
      main_cycle;
      c := cvWaitKey(33);
      if c = 27 then
        Break;
      if c = Ord('r') then
        need_to_init := 1;
      if c = Ord('c') then
        count := 0;
      if c = Ord('n') then
        night_mode := night_mode xor 1;
    end;

    cvReleaseCapture(capture);
    cvReleaseImage(image);
    cvDestroyAllWindows;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
