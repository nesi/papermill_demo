#!/usr/bin/env bash
#SBATCH --time=00-01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gpus-per-node=A100:1
#SBATCH --mem=4GB
#SBATCH --output logs/%j-%x.out
#SBATCH --error logs/%j-%x.out

# activate the conda environment
module purge && module load Miniconda3/4.10.3 cuDNN/8.1.1.33-CUDA-11.2.0
source $(conda info --base)/etc/profile.d/conda.sh
conda activate ./venv

# run the model fitting notebook
papermill -k papermill_demo \
    -p n_epochs 10 \
    -p n_trials 20 \
    -p max_units 256 \
    --cwd results \
    notebooks/keras_model.ipynb \
    results/keras_model.ipynb
