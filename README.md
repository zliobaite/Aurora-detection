Aurora-detection
================

This is an experiment on simple detection of Northern Lights (Aurora Borealis) in camera images. It was coded after visiting aurora researchers in Longyearbyen, Svalbard. 

I tested a few simple approaches: thresholding pixels, and clustering pixels, thei work reasonably well.
run_image_noclust.m - detection with thresholds
run_image_demo.m - detection using custering
run_generate_data.m - generates data for machine learning approaches to detection (approaches are not implemented)
run_video_demo.m and run_video_demo2.m - experiments with detection directly from video
