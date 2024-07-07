import argparse

#################### PREPARATIONS ####################
parser = argparse.ArgumentParser(description='Train YOLO model with custom dataset')

# name of YOLO model
parser.add_argument('-m', '--model', 
    default='yolov8n-cls.pt', 
    help='name of YOLO model (default = yolov8n-cls.pt)')
# epochs count
parser.add_argument('-e', '--epochs_count', 
    default=10,
    help='epochs count (default = 10)')
# dataset path
parser.add_argument('-d', '--dataset_path', 
    required=True,
    help='relative dataset path (required argument)')
# nms
parser.add_argument('-int8', '--int8', 
    default=False,
    help='Activates INT8 quantization, further compressing the model and speeding up inference with minimal accuracy loss, primarily for edge devices. (default = False)')
# half
parser.add_argument('-half', '--half', 
    default=False,
    help='Enables half-precision (FP16) inference, which can speed up model inference on supported GPUs with minimal impact on accuracy (default = False)')

args = parser.parse_args()
print(args)


#################### TRAINING ####################
from ultralytics import YOLO

yolo_model=YOLO(args.model)
yolo_model.train(data=args.dataset_path, epochs=args.epochs_count, augment=True)
yolo_model.export(format='mlmodel',nms=True, half=args.half, int8=args.int8)
