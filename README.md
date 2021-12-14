# Papermill demo

This repository contains a demo of [Papermill](https://papermill.readthedocs.io) running on [NeSI](https://www.nesi.org.nz/).

The goal is to demonstrate how to use it to run non-interactively a series of notebooks on an HPC plateform.


## Installation

Create a Conda environment:
```
module purge && module load Miniconda3/4.10.3
conda env create -p venv -f environment.yml
```

For reproducibility, save the version of installed packages in `environment.lock.txt`:
```
conda env export -p venv --no-builds | sed "/^name/d; /^prefix/d" > environment.lock.yml
```
Note this file can be used to create the environment instead of `environment.yml`.

Install a jupyter kernel for the notebooks:
```
module purge && module load JupyterLab
nesi-add-kernel -p ./venv papermill_demo
```


## Getting Started

Activate the virtual environment:
```
module purge && module load Miniconda3/4.10.3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate ./venv
```

TODO command line

TODO slurm

TODO snakemake
