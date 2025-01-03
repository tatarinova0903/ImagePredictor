# ImagePredictor

## Setup ML model

### Install requirements
Install all libraries from requirements.txt with command: 
```bash
pip install -r requirements.txt
```

### Prepare dataset
You can create your own dataset.

**IMPORTANT!** It should have such struct:
```
├── train
│   ├── image11.ext
|   ├── image12.ext
│   └── image13.ext
└── test
    ├── image21.ext
    ├── image22.ext
    └── image23.ext
```

If your dataset does not have such struct you can reorganize it by using `prepare_dataset.py` script.

```bash
python prepare_dataset.py -s YOUR_DATASET_DIR
```

Run next command to view all script arguments
```bash
python prepare_dataset.py -h
```

### Create mlmodel
To create `mlmodel` run `train.py`

```bash
python train.py -d YOUR_RESULT_DATASET_DIR
```

Run next command to view all script arguments
```bash
python train.py -h
```

`train.py` script will create mlmodel which can be used in iOS CoreML app.

## Use your ML model in iOS app
