# inspiré de : https://github.com/rwightman/posenet-pytorch

import torch
import cv2
import time
import argparse

import detectors.posenet as posenet

class BodyDetector:

    def __init__(self, image, model=101):
        model = posenet.load_model(model)
        model = model.cuda()
        self.model = model
        self.output_stride = model.output_stride
        self.scale_factor = 0.7125
        self.start = time.time()
        self.frame_count = 0

    def get_body(self, image, drawArms=False, drawLegs=False):
        input_image, display_image, output_scale = posenet.process_input(
            image, scale_factor=self.scale_factor, output_stride=self.output_stride)

        with torch.no_grad():
            input_image = torch.Tensor(input_image).cuda()

            heatmaps_result, offsets_result, displacement_fwd_result, displacement_bwd_result = self.model(input_image)

            pose_scores, keypoint_scores, keypoint_coords = posenet.decode_multiple_poses(
                heatmaps_result.squeeze(0),
                offsets_result.squeeze(0),
                displacement_fwd_result.squeeze(0),
                displacement_bwd_result.squeeze(0),
                output_stride=self.output_stride,
                max_pose_detections=1,
                min_pose_score=0.15)

        keypoint_coords *= output_scale

        if drawArms:
            overlay_image = posenet.draw_skel_and_arms(
                display_image, pose_scores, keypoint_scores, keypoint_coords,
                min_pose_score=0.15, min_part_score=0.1)
        elif drawLegs:
            overlay_image = posenet.draw_skel_and_legs(
                display_image, pose_scores, keypoint_scores, keypoint_coords,
                min_pose_score=0.15, min_part_score=0.1)

        self.frame_count += 1

        return overlay_image, keypoint_coords